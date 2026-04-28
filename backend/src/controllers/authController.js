const bcrypt = require('bcryptjs');

const User = require('../models/User');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../utils/asyncHandler');
const {
    issueAccessToken,
    issueRefreshToken,
    hashToken,
} = require('../utils/tokens');

function validatePasswordStrength(password) {
    return typeof password === 'string' && password.length >= 8 && /[A-Za-z]/.test(password) && /\d/.test(password);
}

function buildAuthPayload(user, accessToken, refreshToken) {
    return {
        user,
        token: accessToken,
        refreshToken,
    };
}

function sanitizeUser(user) {
    return user.toJSON ? user.toJSON() : user;
}

const register = asyncHandler(async (req, res) => {
    const {
        email,
        password,
        name,
        phone,
        sports = [],
        level = 'beginner',
        latitude = null,
        longitude = null,
        photoUrl = '',
    } = req.body;

    if (!email || !password || !name || !phone) {
        throw new ApiError(400, 'email, password, name, and phone are required');
    }

    if (!validatePasswordStrength(password)) {
        throw new ApiError(400, 'Password must be at least 8 characters and contain letters and numbers');
    }

    const existingUser = await User.findOne({ email: email.toLowerCase() });
    if (existingUser) {
        throw new ApiError(409, 'Email is already registered');
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    const user = await User.create({
        email,
        password: hashedPassword,
        name,
        phone,
        sports: Array.isArray(sports) ? sports : [],
        level,
        latitude,
        longitude,
        photoUrl,
    });

    const accessToken = issueAccessToken(user._id);
    const refreshToken = issueRefreshToken(user._id);

    user.refreshTokenHash = hashToken(refreshToken);
    await user.save({ validateBeforeSave: false });

    res.status(201).json(buildAuthPayload(sanitizeUser(user), accessToken, refreshToken));
});

const login = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        throw new ApiError(400, 'email and password are required');
    }

    const user = await User.findOne({ email: email.toLowerCase() }).select('+password');
    if (!user) {
        throw new ApiError(401, 'Invalid email or password');
    }

    const passwordMatches = await bcrypt.compare(password, user.password);
    if (!passwordMatches) {
        throw new ApiError(401, 'Invalid email or password');
    }

    const accessToken = issueAccessToken(user._id);
    const refreshToken = issueRefreshToken(user._id);

    user.refreshTokenHash = hashToken(refreshToken);
    await user.save({ validateBeforeSave: false });

    const safeUser = await User.findById(user._id).select('-password');
    res.status(200).json(buildAuthPayload(safeUser, accessToken, refreshToken));
});

const logout = asyncHandler(async (req, res) => {
    const user = await User.findById(req.user._id).select('+refreshTokenHash');
    if (user) {
        user.refreshTokenHash = null;
        await user.save({ validateBeforeSave: false });
    }

    res.status(200).json({ message: 'Logout successful' });
});

const me = asyncHandler(async (req, res) => {
    res.status(200).json({ user: req.user });
});

const refreshToken = asyncHandler(async (req, res) => {
    const user = await User.findById(req.user._id).select('+refreshTokenHash');

    if (!user || !user.refreshTokenHash) {
        throw new ApiError(401, 'Refresh token is not active');
    }

    if (user.refreshTokenHash !== hashToken(req.token)) {
        throw new ApiError(401, 'Refresh token mismatch');
    }

    const newAccessToken = issueAccessToken(user._id);
    const newRefreshToken = issueRefreshToken(user._id);

    user.refreshTokenHash = hashToken(newRefreshToken);
    await user.save({ validateBeforeSave: false });

    res.status(200).json({
        token: newAccessToken,
        refreshToken: newRefreshToken,
    });
});

module.exports = {
    register,
    login,
    logout,
    me,
    refreshToken,
};