const Event = require('../models/Event');
const Rating = require('../models/Rating');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../utils/asyncHandler');

async function recalculateEventRating(eventId) {
    const aggregate = await Rating.aggregate([
        { $match: { eventId } },
        {
            $group: {
                _id: '$eventId',
                averageRating: { $avg: '$score' },
                reviewCount: { $sum: 1 },
            },
        },
    ]);

    const [summary] = aggregate;
    await Event.findByIdAndUpdate(eventId, {
        averageRating: summary ? summary.averageRating : 0,
        reviewCount: summary ? summary.reviewCount : 0,
    });
}

const createRating = asyncHandler(async (req, res) => {
    const { eventId, score, review = '' } = req.body;

    if (!eventId || score === undefined) {
        throw new ApiError(400, 'eventId and score are required');
    }

    if (score < 1 || score > 5 || !Number.isInteger(score)) {
        throw new ApiError(400, 'Score must be an integer between 1 and 5');
    }

    const event = await Event.findById(eventId);
    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    if (new Date(event.endTime).getTime() > Date.now()) {
        throw new ApiError(400, 'Rating is allowed only after the event has ended');
    }

    const joinedUser = event.joinedUsers.some((participant) => participant.toString() === req.user._id.toString());
    if (!joinedUser) {
        throw new ApiError(403, 'You can only rate events you have joined');
    }

    const existingRating = await Rating.findOne({ eventId, userId: req.user._id });
    if (existingRating) {
        throw new ApiError(409, 'You already rated this event. Use PUT to update it.');
    }

    const rating = await Rating.create({
        eventId,
        userId: req.user._id,
        score,
        review,
    });

    await recalculateEventRating(eventId);
    res.status(201).json({ rating });
});

const listRatingsByEvent = asyncHandler(async (req, res) => {
    const { page = 1, limit = 10 } = req.query;
    const pageNumber = Math.max(parseInt(page, 10) || 1, 1);
    const limitNumber = Math.min(Math.max(parseInt(limit, 10) || 10, 1), 100);
    const skip = (pageNumber - 1) * limitNumber;

    const [ratings, total] = await Promise.all([
        Rating.find({ eventId: req.params.eventId })
            .sort({ created_at: -1 })
            .skip(skip)
            .limit(limitNumber)
            .populate('userId', 'name email photoUrl'),
        Rating.countDocuments({ eventId: req.params.eventId }),
    ]);

    res.status(200).json({
        ratings,
        total,
    });
});

const listRatingsByUser = asyncHandler(async (req, res) => {
    const ratings = await Rating.find({ userId: req.params.userId }).sort({ created_at: -1 }).populate('eventId', 'name sport location startTime endTime');

    res.status(200).json({ ratings });
});

const updateRating = asyncHandler(async (req, res) => {
    const rating = await Rating.findById(req.params.id);

    if (!rating) {
        throw new ApiError(404, 'Rating not found');
    }

    if (rating.userId.toString() !== req.user._id.toString()) {
        throw new ApiError(403, 'You are not allowed to update this rating');
    }

    if (req.body.score !== undefined) {
        rating.score = req.body.score;
    }

    if (req.body.review !== undefined) {
        rating.review = req.body.review;
    }

    await rating.save();
    await recalculateEventRating(rating.eventId);

    res.status(200).json({ rating });
});

const deleteRating = asyncHandler(async (req, res) => {
    const rating = await Rating.findById(req.params.id);

    if (!rating) {
        throw new ApiError(404, 'Rating not found');
    }

    if (rating.userId.toString() !== req.user._id.toString()) {
        throw new ApiError(403, 'You are not allowed to delete this rating');
    }

    await Rating.deleteOne({ _id: rating._id });
    await recalculateEventRating(rating.eventId);

    res.status(200).json({ message: 'Rating deleted' });
});

module.exports = {
    createRating,
    listRatingsByEvent,
    listRatingsByUser,
    updateRating,
    deleteRating,
};