const ApiError = require('../utils/ApiError');

function notFound(_req, _res, next) {
    next(new ApiError(404, 'Route not found'));
}

function errorHandler(error, _req, res, _next) {
    const statusCode = error.statusCode || 500;
    const message = error.message || 'Internal Server Error';

    res.status(statusCode).json({
        message,
    });
}

module.exports = {
    notFound,
    errorHandler,
};