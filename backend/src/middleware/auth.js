const jwt = require('jsonwebtoken');

const User = require('../models/User');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../utils/asyncHandler');

function buildSecrets(allowedTypes) {
    return allowedTypes.map((type) => {
        if (type === 'refresh') {
            return { type, secret: process.env.JWT_REFRESH_SECRET };
        }

        return { type, secret: process.env.JWT_SECRET };
    });
}

function authenticate(allowedTypes = ['access']) {
    return asyncHandler(async (req, _res, next) => {
        const authHeader = req.headers.authorization || '';
        const [scheme, token] = authHeader.split(' ');

        if (scheme !== 'Bearer' || !token) {
            throw new ApiError(401, 'Authorization token is required');
        }

        const secrets = buildSecrets(allowedTypes);
        let decoded = null;

        for (const item of secrets) {
            try {
                decoded = jwt.verify(token, item.secret);
                if (decoded.type === item.type) {
                    break;
                }
                decoded = null;
            } catch (_error) {
                decoded = null;
            }
        }

        if (!decoded) {
            throw new ApiError(401, 'Invalid or expired token');
        }

        const user = await User.findById(decoded.sub).select('-password');
        if (!user) {
            throw new ApiError(401, 'User not found');
        }

        req.user = user;
        req.token = token;
        next();
    });
}

module.exports = authenticate;