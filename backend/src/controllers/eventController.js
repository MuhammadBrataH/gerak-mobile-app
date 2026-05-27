const Event = require('../models/Event');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../utils/asyncHandler');

function parseCoordinates(source) {
    if (!source) {
        return null;
    }

    if (Array.isArray(source) && source.length === 2) {
        return [Number(source[0]), Number(source[1])];
    }

    if (typeof source === 'object') {
        const longitude = source.longitude ?? source.lng ?? source.lon;
        const latitude = source.latitude ?? source.lat;

        if (longitude !== undefined && latitude !== undefined) {
            return [Number(longitude), Number(latitude)];
        }
    }

    return null;
}

function parseNumber(value, fallback = null) {
    if (value === undefined || value === null || value === '') {
        return fallback;
    }

    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : fallback;
}

function normalizeCreateEventPayload(user, body) {
    const {
        name,
        description = '',
        sport,
        level,
        startTime,
        endTime,
        location,
        city,
        district = '',
        coordinates,
        maxSlots,
        totalSlots,
        adminPhone,
        imageUrl = '',
        activityType = 'match',
    } = body;

    const isPost = activityType === 'post';
    const normalizedStartTime = isPost ? new Date() : startTime;
    const normalizedEndTime = isPost ? new Date() : endTime;
    const normalizedSport = isPost ? sport || user.sports?.[0] || 'general' : sport;
    const normalizedLevel = isPost ? 'mixed' : level;
    const normalizedLocation = isPost ? location || 'Postingan Komunitas' : location;
    const normalizedTotalSlotsInput = isPost ? 1 : totalSlots;
    const normalizedMaxSlotsInput = isPost ? 1 : maxSlots;

    return {
        name,
        description,
        sport: normalizedSport || 'general',
        level: normalizedLevel || 'mixed',
        startTime: normalizedStartTime,
        endTime: normalizedEndTime,
        location: normalizedLocation,
        city,
        district,
        coordinates,
        totalSlots: parseNumber(normalizedTotalSlotsInput, parseNumber(normalizedMaxSlotsInput, 0)),
        maxSlots: parseNumber(normalizedMaxSlotsInput, parseNumber(normalizedTotalSlotsInput, 0)),
        adminPhone: adminPhone || user.phone,
        imageUrl,
        activityType,
    };
}

async function populateEvent(event) {
    if (!event) {
        return null;
    }

    await event.populate([
        { path: 'joinedUsers', select: 'name email phone photoUrl level sports' },
        { path: 'createdBy', select: 'name email phone photoUrl' },
    ]);

    return event;
}

const listEvents = asyncHandler(async (req, res) => {
    const {
        sport,
        level,
        city,
        district,
        createdBy,
        activityType,
        page = 1,
        limit = 10,
    } = req.query;

    const query = {};

    if (sport) {
        query.sport = sport;
    }

    if (level) {
        query.level = level;
    }

    if (city) {
        query.city = { $regex: city, $options: 'i' };
    }

    if (district) {
        query.district = { $regex: district, $options: 'i' };
    }

    if (createdBy) {
        query.createdBy = createdBy;
    }

    if (activityType) {
        query.activityType = activityType;
    }

    const pageNumber = Math.max(Number.parseInt(page, 10) || 1, 1);
    const limitNumber = Math.min(Math.max(Number.parseInt(limit, 10) || 10, 1), 100);
    const skip = (pageNumber - 1) * limitNumber;

    const sort = activityType === 'post' ? { created_at: -1 } : { startTime: 1 };

    const [events, total] = await Promise.all([
        Event.find(query)
            .sort(sort)
            .skip(skip)
            .limit(limitNumber),
        Event.countDocuments(query),
    ]);

    res.status(200).json({
        events,
        total,
        page: pageNumber,
    });
});

const getEventById = asyncHandler(async (req, res) => {
    const event = await populateEvent(await Event.findById(req.params.id));

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    res.status(200).json({ event });
});

const createEvent = asyncHandler(async (req, res) => {
    // Only community accounts (organizers) can create events
    if (req.user?.accountType !== 'community') {
        throw new ApiError(403, 'Only community accounts can create events');
    }

    const payload = normalizeCreateEventPayload(req.user, req.body);

    if (!['post', 'match'].includes(payload.activityType)) {
        throw new ApiError(400, 'activityType must be either "post" or "match"');
    }

    if (!payload.name || !payload.city || !payload.adminPhone) {
        throw new ApiError(400, 'name, city, and adminPhone are required');
    }

    if (payload.activityType === 'match' && (!payload.sport || !payload.level || !payload.startTime || !payload.endTime || !payload.location)) {
        throw new ApiError(400, 'name, sport, level, startTime, endTime, location, city, and adminPhone are required');
    }

    if (!payload.totalSlots || !payload.maxSlots) {
        throw new ApiError(400, 'totalSlots or maxSlots must be greater than zero');
    }

    const eventData = {
        ...payload,
        createdBy: req.user._id,
    };

    // Coordinates are optional for MVP (will be for phase 2 GPS feature)
    if (payload.coordinates) {
        const parsedCoordinates = parseCoordinates(payload.coordinates);
        if (parsedCoordinates) {
            eventData.coordinates = {
                type: 'Point',
                coordinates: parsedCoordinates,
            };
        }
    }

    const event = await Event.create(eventData);
    const populatedEvent = await populateEvent(event);
    res.status(201).json({ event: populatedEvent });
});

const updateEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    if (event.createdBy.toString() !== req.user._id.toString()) {
        throw new ApiError(403, 'You are not allowed to update this event');
    }

    const fields = ['name', 'description', 'sport', 'level', 'startTime', 'endTime', 'location', 'city', 'district', 'adminPhone', 'imageUrl'];
    for (const field of fields) {
        if (req.body[field] !== undefined) {
            event[field] = req.body[field];
        }
    }

    if (req.body.coordinates !== undefined) {
        const parsedCoordinates = parseCoordinates(req.body.coordinates);
        if (!parsedCoordinates) {
            throw new ApiError(400, 'coordinates must include longitude and latitude');
        }
        event.coordinates = {
            type: 'Point',
            coordinates: parsedCoordinates,
        };
    }

    if (req.body.totalSlots !== undefined) {
        event.totalSlots = parseNumber(req.body.totalSlots, event.totalSlots);
    }

    if (req.body.maxSlots !== undefined) {
        event.maxSlots = parseNumber(req.body.maxSlots, event.maxSlots);
    }

    await event.save();

    const populatedEvent = await populateEvent(event);
    res.status(200).json({ event: populatedEvent });
});

const deleteEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    if (event.createdBy.toString() !== req.user._id.toString()) {
        throw new ApiError(403, 'You are not allowed to delete this event');
    }

    await Event.deleteOne({ _id: event._id });
    res.status(200).json({ message: 'Event deleted' });
});

const joinEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    const userId = req.user._id.toString();
    const joined = event.joinedUsers.map((participant) => participant.toString());

    if (joined.includes(userId)) {
        throw new ApiError(409, 'You already joined this event');
    }

    if (event.joinedUsers.length >= event.maxSlots) {
        throw new ApiError(409, 'Event is already full');
    }

    event.joinedUsers.push(req.user._id);
    await event.save();

    const populatedEvent = await populateEvent(event);
    res.status(200).json({
        message: 'Join successful',
        event: populatedEvent,
    });
});

const leaveEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    event.joinedUsers = event.joinedUsers.filter((participant) => participant.toString() !== req.user._id.toString());
    await event.save();

    const populatedEvent = await populateEvent(event);
    res.status(200).json({
        message: 'Leave successful',
        event: populatedEvent,
    });
});

const getParticipants = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id).populate('joinedUsers', 'name email phone photoUrl level sports');

    if (!event) {
        throw new ApiError(404, 'Event not found');
    }

    res.status(200).json({
        participants: event.joinedUsers,
    });
});

module.exports = {
    listEvents,
    getEventById,
    createEvent,
    updateEvent,
    deleteEvent,
    joinEvent,
    leaveEvent,
    getParticipants,
};