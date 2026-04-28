const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            trim: true,
        },
        description: {
            type: String,
            default: '',
            trim: true,
        },
        sport: {
            type: String,
            required: true,
            trim: true,
        },
        level: {
            type: String,
            enum: ['beginner', 'intermediate', 'advanced', 'mixed'],
            required: true,
        },
        startTime: {
            type: Date,
            required: true,
        },
        endTime: {
            type: Date,
            required: true,
        },
        location: {
            type: String,
            required: true,
            trim: true,
        },
        city: {
            type: String,
            required: true,
            trim: true,
            index: true,
        },
        district: {
            type: String,
            default: '',
            trim: true,
            index: true,
        },
        coordinates: {
            type: {
                type: String,
                enum: ['Point'],
                default: 'Point',
            },
            coordinates: {
                type: [Number],
                default: null,
            },
        },
        totalSlots: {
            type: Number,
            required: true,
            min: 1,
        },
        maxSlots: {
            type: Number,
            required: true,
            min: 1,
        },
        adminPhone: {
            type: String,
            required: true,
            trim: true,
        },
        imageUrl: {
            type: String,
            default: '',
        },
        joinedUsers: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'User',
            },
        ],
        averageRating: {
            type: Number,
            default: 0,
        },
        reviewCount: {
            type: Number,
            default: 0,
        },
        createdBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,
        },
    },
    {
        timestamps: {
            createdAt: 'created_at',
            updatedAt: 'updated_at',
        },
    }
);

eventSchema.index({ coordinates: '2dsphere' });

module.exports = mongoose.model('Event', eventSchema);