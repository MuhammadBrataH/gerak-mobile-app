#!/usr/bin/env node
/**
 * Clear MongoDB collections for fresh testing
 */

const mongoose = require('mongoose');
require('dotenv').config();

(async () => {
    try {
        const mongoUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/gerak';
        await mongoose.connect(mongoUri);
        console.log('Connected to MongoDB');

        // Drop all collections
        await mongoose.connection.db.dropDatabase();
        console.log('✓ Database cleared successfully');

        await mongoose.disconnect();
        console.log('✓ Disconnected');
    } catch (err) {
        console.error('Error:', err.message);
        process.exit(1);
    }
})();
