#!/usr/bin/env node

/**
 * Backfill missing accountType values for legacy users.
 *
 * Rule:
 * - users whose name/email contains xtc, polban, or usf => community
 * - all other users missing accountType => personal
 * - existing accountType values are preserved
 */

const mongoose = require('mongoose');
require('dotenv').config();

const User = require('./src/models/User');

const COMMUNITY_KEYWORDS = ['xtc', 'polban', 'usf'];

function inferAccountType(user) {
    const haystack = `${user.name || ''} ${user.email || ''}`.toLowerCase();
    return COMMUNITY_KEYWORDS.some((keyword) => haystack.includes(keyword))
        ? 'community'
        : 'personal';
}

(async () => {
    try {
        const mongoUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/gerak';
        await mongoose.connect(mongoUri);
        console.log('Connected to MongoDB');

        const legacyUsers = await User.find({
            $or: [
                { accountType: { $exists: false } },
                { accountType: null },
                { accountType: '' },
            ],
        });

        console.log(`Found ${legacyUsers.length} users without accountType`);

        let updatedCount = 0;
        for (const user of legacyUsers) {
            const accountType = inferAccountType(user);
            user.accountType = accountType;
            await user.save();
            updatedCount += 1;
            console.log(`Updated ${user.email} -> ${accountType}`);
        }

        console.log(`✓ Migration complete. Updated ${updatedCount} users.`);
        await mongoose.disconnect();
        console.log('✓ Disconnected');
    } catch (err) {
        console.error('Error:', err.message);
        process.exit(1);
    }
})();