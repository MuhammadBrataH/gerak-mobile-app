# 🔨 Ersya's Week 4 Backend Development Task List
**Status:** Development Phase Started  
**Role:** PM (30%) + Backend Developer (70%)

---

## ✅ COMPLETED (Already in Code)
- ✅ Join/Leave Event system
- ✅ Get Participants
- ✅ Rating system (Create, Read, Update, Delete)
- ✅ Event CRUD operations

---

## 🔧 IMMEDIATE TASKS (Fix & Optimize)

### Task 1: Fix listEvents() Pagination Bug ⚠️
**File:** `backend/src/controllers/eventController.js`

**Issue:** Pagination not applied, returns all results
```javascript
// Current (BROKEN):
const [events, total] = await Promise.all([
    Event.find(query)
        .sort({ startTime: 1 })
]);

// Should be:
const [events, total] = await Promise.all([
    Event.find(query)
        .sort({ startTime: 1 })
        .skip(skip)
        .limit(limitNumber),
    Event.countDocuments(query),
]);
```

**Status:** 🔴 CRITICAL - Need to fix NOW

---

### Task 2: Fix createEvent() - Missing city/district Validation ⚠️
**File:** `backend/src/controllers/eventController.js`

**Issue:** city/district fields not in destructuring, coordinates validation too strict

**Required Fix:**
```javascript
// Update destructuring to include city, district
const {
    name,
    description = '',
    sport,
    level,
    startTime,
    endTime,
    location,
    city,              // ADD THIS
    district = '',     // ADD THIS
    coordinates,
    maxSlots,
    totalSlots,
    adminPhone,
    imageUrl = '',
} = req.body;

// Update validation - city REQUIRED
if (!name || !sport || !level || !startTime || !endTime || !location || !city || !adminPhone) {
    throw new ApiError(400, 'name, sport, level, startTime, endTime, location, city, and adminPhone are required');
}

// Make coordinates OPTIONAL
const eventData = {
    name,
    description,
    sport,
    level,
    startTime,
    endTime,
    location,
    city,           // NEW
    district,       // NEW
    totalSlots: normalizedTotalSlots,
    maxSlots: normalizedMaxSlots,
    adminPhone,
    imageUrl,
    createdBy: req.user._id,
};

if (coordinates) {
    const parsedCoordinates = parseCoordinates(coordinates);
    if (parsedCoordinates) {
        eventData.coordinates = {
            type: 'Point',
            coordinates: parsedCoordinates,
        };
    }
}

const event = await Event.create(eventData);
```

**Status:** 🔴 CRITICAL - Required for MVP (city/district spec)

---

### Task 3: Add Input Validation for Score in Rating ⚠️
**File:** `backend/src/controllers/ratingController.js`

**Issue:** No score range validation (1-5)

**Fix:**
```javascript
if (score < 1 || score > 5) {
    throw new ApiError(400, 'Score must be between 1 and 5');
}
```

**Status:** 🟠 IMPORTANT - Data quality

---

## 📝 DOCUMENTATION TASKS

### Task 4: Add API Documentation
Create `backend/API_DOCUMENTATION.md` with endpoints:

```markdown
# GERAK API Documentation

## Events Endpoints

### List Events
GET /events?city=Jakarta&sport=futsal&level=beginner&page=1&limit=10
```

**Status:** 🟡 NICE-TO-HAVE - Can do after core fixes

---

## 🧪 TESTING IMPROVEMENTS

### Task 5: Update test-api-simple.js for Rating System
**File:** `backend/test-api-simple.js`

Add tests for:
- Create rating (post-event)
- List ratings for event
- Update rating
- Delete rating

**Status:** 🟠 IMPORTANT - Need for verification

---

## 🎯 PRIORITY ORDER (What to do First)

1. **🔴 P0 - FIX BUGS (Today)**
   - [ ] Fix listEvents() pagination
   - [ ] Fix createEvent() city/district fields
   - [ ] Add score validation in rating

2. **🟠 P1 - TESTING (Tomorrow)**
   - [ ] Update test suite with fixes
   - [ ] Run full API test
   - [ ] Verify all endpoints

3. **🟡 P2 - DOCUMENTATION (This Week)**
   - [ ] Write API docs
   - [ ] Add code comments
   - [ ] Update README

---

## 💪 Let's Start: Fix Bug #1 - listEvents() Pagination

**Action:** Open `eventController.js` at line 75-85 and apply fix above

**Why:** Without pagination, API returns EVERYTHING which is slow and breaks spec
