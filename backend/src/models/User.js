const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
    {
        email: {
            type: String,
            required: true,
            unique: true,
            trim: true,
            lowercase: true,
            index: true,
        },
        password: {
            type: String,
            required: false,
            select: false,
        },
        name: {
            type: String,
            required: true,
            trim: true,
        },
        phone: {
            type: String,
            required: false,
            trim: true,
        },
        photoUrl: {
            type: String,
            default: '',
        },
        sports: {
            type: [String],
            default: [],
        },
        level: {
            type: String,
            enum: ['beginner', 'intermediate', 'advanced'],
            default: 'beginner',
        },
        accountType: {
            type: String,
            enum: ['personal', 'community'],
            default: 'personal',
        },
        gender: {
            type: String,
            default: null,
        },
        dateOfBirth: {
            type: Date,
            default: null,
        },
        latitude: {
            type: Number,
            default: null,
        },
        longitude: {
            type: Number,
            default: null,
        },
        refreshTokenHash: {
            type: String,
            default: null,
        },
        googleId: { 
            type: String, 
            default: null },
    },
    {
        timestamps: {
            createdAt: 'created_at',
            updatedAt: 'updated_at',
        },
    }
    
);

userSchema.set('toJSON', {
    transform(_doc, ret) {
        delete ret.password;
        delete ret.refreshTokenHash;
        delete ret.__v;
        return ret;
    },
});

module.exports = mongoose.model('User', userSchema);