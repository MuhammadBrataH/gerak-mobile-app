const crypto = require('crypto');
const jwt = require('jsonwebtoken');

function issueAccessToken(userId) {
    return jwt.sign({ type: 'access' }, process.env.JWT_SECRET, {
        subject: userId.toString(),
        expiresIn: '24h',
    });
}

function issueRefreshToken(userId) {
    return jwt.sign({ type: 'refresh' }, process.env.JWT_REFRESH_SECRET, {
        subject: userId.toString(),
        expiresIn: '7d',
    });
}

function hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex');
}

module.exports = {
    issueAccessToken,
    issueRefreshToken,
    hashToken,
};