const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const authRoutes = require('./routes/authRoutes');
const eventRoutes = require('./routes/eventRoutes');
const ratingRoutes = require('./routes/ratingRoutes');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const app = express();

app.use(helmet());
app.use(
    cors({
        origin: process.env.CORS_ORIGIN || '*',
        credentials: true,
    })
);
app.use(express.json({ limit: '25mb' }));
app.use(express.urlencoded({ extended: true, limit: '25mb' }));
app.use(morgan('dev'));

app.get('/health', (_req, res) => {
    res.status(200).json({
        status: 'ok',
        service: 'gerak-backend',
    });
});

app.use('/auth', authRoutes);
app.use('/events', eventRoutes);
app.use('/ratings', ratingRoutes);

app.use(notFound);
app.use(errorHandler);

module.exports = app;