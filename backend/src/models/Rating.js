const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema(
    {
        eventId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Event',
            required: true,
            index: true,
        },
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,
            index: true,
        },
        score: {
            type: Number,
            required: true,
            min: 1,
            max: 5,
        },
        review: {
            type: String,
            default: '',
            trim: true,
            maxlength: 500,
        },
    },
    {
        timestamps: {
            createdAt: 'created_at',
            updatedAt: false,
        },
    }
);

ratingSchema.index({ eventId: 1, userId: 1 }, { unique: true });

module.exports = mongoose.model('Rating', ratingSchema);