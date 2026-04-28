#!/usr/bin/env node
/**
 * Clear MongoDB collections for fresh testing
 */

const mongoose = require('mongoose');

(async () => {
    try {
        await mongoose.connect('mongodb://127.0.0.1:27017/gerak');
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
