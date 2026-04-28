# 🛠️ GERAK Week 4 Backend Development Roadmap
**Team:** Ersya (PM + Backend Dev), Abi (UI/UX), Brata (Flutter Dev)  
**Status:** Sprint Planning Phase  
**Duration:** Week 4 (After testing phase)

---

## 👤 Updated Team Roles

### Ersya - PM + Backend Developer (50% PM / 50% Backend Dev)
**Week 4 Responsibilities:**
- ✅ Continue project coordination & stakeholder management
- ✅ Backend feature implementation & code review
- ✅ Backend architecture decisions
- ✅ Database schema optimization
- ✅ API design & documentation

### Abi - UI/UX Designer
- Finalize Figma designs
- Create regional filter UI components
- Design event list/detail screens

### Brata - Flutter Developer
- Implement frontend features
- Consume GERAK API
- Handle app state management

---

## 🎯 Week 4 Backend Sprint

### PHASE 1: Core Features (Days 1-2)
**Owner: Ersya (Backend)**

#### Task 1.1: Implement Join Event Feature
**File:** `backend/src/controllers/eventController.js` → `joinEvent()` function

```javascript
const joinEvent = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const userId = req.user._id;

  // Find event
  const event = await Event.findById(id);
  if (!event) throw new ApiError(404, 'Event not found');

  // Check if already joined
  if (event.joinedUsers.includes(userId)) {
    throw new ApiError(400, 'User already joined this event');
  }

  // Check slot availability
  if (event.joinedUsers.length >= event.maxSlots) {
    throw new ApiError(400, 'Event is full');
  }

  // Add user to event
  event.joinedUsers.push(userId);
  await event.save();

  // Return updated event with populated data
  const populatedEvent = await populateEvent(event);
  res.status(200).json({ event: populatedEvent });
});
```

**Acceptance Criteria:**
- ✅ Reject join if user already joined
- ✅ Reject join if event is full
- ✅ Return 200 with updated event
- ✅ User appears in joinedUsers array

---

#### Task 1.2: Implement Leave Event Feature
**File:** `backend/src/controllers/eventController.js` → `leaveEvent()` function

```javascript
const leaveEvent = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const userId = req.user._id;

  const event = await Event.findById(id);
  if (!event) throw new ApiError(404, 'Event not found');

  // Check if user joined
  if (!event.joinedUsers.includes(userId)) {
    throw new ApiError(400, 'User is not part of this event');
  }

  // Remove user from event
  event.joinedUsers = event.joinedUsers.filter(
    uid => uid.toString() !== userId.toString()
  );
  await event.save();

  const populatedEvent = await populateEvent(event);
  res.status(200).json({ event: populatedEvent });
});
```

**Acceptance Criteria:**
- ✅ Only leave if user joined
- ✅ Remove user from joinedUsers
- ✅ Return updated event

---

#### Task 1.3: Get Event Participants
**File:** `backend/src/controllers/eventController.js` → `getParticipants()` function

```javascript
const getParticipants = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const { page = 1, limit = 10 } = req.query;

  const event = await Event.findById(id).populate('joinedUsers');
  if (!event) throw new ApiError(404, 'Event not found');

  const pageNumber = Math.max(parseInt(page, 10) || 1, 1);
  const limitNumber = Math.min(Math.max(parseInt(limit, 10) || 10, 1), 100);
  const skip = (pageNumber - 1) * limitNumber;

  const participants = event.joinedUsers.slice(skip, skip + limitNumber);

  res.status(200).json({
    participants,
    total: event.joinedUsers.length,
    page: pageNumber,
  });
});
```

**Acceptance Criteria:**
- ✅ Return paginated participants
- ✅ Include total count
- ✅ Only return public fields (name, level, etc)

---

### PHASE 2: Rating System (Days 3-4)
**Owner: Ersya (Backend)**

#### Task 2.1: Create Rating
**File:** `backend/src/controllers/ratingController.js` → `createRating()` function

```javascript
const createRating = asyncHandler(async (req, res) => {
  const { eventId, score, review } = req.body;
  const userId = req.user._id;

  if (!eventId || score === undefined || score === null) {
    throw new ApiError(400, 'eventId and score are required');
  }

  if (score < 1 || score > 5) {
    throw new ApiError(400, 'Score must be between 1 and 5');
  }

  // Check event exists
  const event = await Event.findById(eventId);
  if (!event) throw new ApiError(404, 'Event not found');

  // Check user was participant
  if (!event.joinedUsers.includes(userId)) {
    throw new ApiError(400, 'Only participants can rate this event');
  }

  // Check event is in past
  if (new Date() < new Date(event.endTime)) {
    throw new ApiError(400, 'Cannot rate event before it ends');
  }

  // Check duplicate rating
  const existing = await Rating.findOne({ eventId, userId });
  if (existing) {
    throw new ApiError(400, 'You already rated this event');
  }

  const rating = await Rating.create({
    eventId,
    userId,
    score,
    review: review || '',
  });

  // Recalculate event rating
  await recalculateEventRating(eventId);

  res.status(201).json({ rating });
});
```

**Acceptance Criteria:**
- ✅ Validate score 1-5
- ✅ Check user is participant
- ✅ Check event is past
- ✅ Prevent duplicate ratings
- ✅ Update event averageRating

---

#### Task 2.2: List Ratings for Event
**File:** `backend/src/controllers/ratingController.js` → `listRatingsByEvent()` function

```javascript
const listRatingsByEvent = asyncHandler(async (req, res) => {
  const { eventId } = req.params;
  const { page = 1, limit = 5 } = req.query;

  const pageNumber = Math.max(parseInt(page, 10) || 1, 1);
  const limitNumber = Math.min(Math.max(parseInt(limit, 10) || 5, 1), 50);
  const skip = (pageNumber - 1) * limitNumber;

  const [ratings, total] = await Promise.all([
    Rating.find({ eventId })
      .populate('userId', 'name level photoUrl')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNumber),
    Rating.countDocuments({ eventId }),
  ]);

  res.status(200).json({
    ratings,
    total,
    page: pageNumber,
  });
});
```

---

### PHASE 3: API Enhancements (Days 5)
**Owner: Ersya (Backend)**

#### Task 3.1: Update Event Endpoint
Add missing fields to event update:

```javascript
// PUT /events/:id
const updateEvent = asyncHandler(async (req, res) => {
  const event = await Event.findById(req.params.id);
  if (!event) throw new ApiError(404, 'Event not found');

  // Check authorization (only creator can update)
  if (event.createdBy.toString() !== req.user._id.toString()) {
    throw new ApiError(403, 'Not authorized to update this event');
  }

  const fields = [
    'name', 'description', 'sport', 'level', 
    'startTime', 'endTime', 'location', 
    'city', 'district', 'adminPhone', 'imageUrl'
  ];

  fields.forEach(field => {
    if (req.body[field] !== undefined) {
      event[field] = req.body[field];
    }
  });

  await event.save();
  const populatedEvent = await populateEvent(event);
  res.status(200).json({ event: populatedEvent });
});
```

---

#### Task 3.2: Delete Event Endpoint
```javascript
// DELETE /events/:id
const deleteEvent = asyncHandler(async (req, res) => {
  const event = await Event.findById(req.params.id);
  if (!event) throw new ApiError(404, 'Event not found');

  if (event.createdBy.toString() !== req.user._id.toString()) {
    throw new ApiError(403, 'Not authorized to delete this event');
  }

  // Delete associated ratings
  await Rating.deleteMany({ eventId: req.params.id });

  await Event.deleteOne({ _id: req.params.id });

  res.status(200).json({ message: 'Event deleted successfully' });
});
```

---

## 📋 Implementation Checklist

### Join/Leave Events
- [ ] Implement joinEvent() controller
- [ ] Implement leaveEvent() controller
- [ ] Implement getParticipants() controller
- [ ] Add route handlers: POST /events/:id/join, POST /events/:id/leave, GET /events/:id/participants
- [ ] Test with API calls
- [ ] Update error handling

### Rating System
- [ ] Implement createRating() controller
- [ ] Implement listRatingsByEvent() controller
- [ ] Implement updateRating() controller
- [ ] Implement deleteRating() controller
- [ ] Add recalculateEventRating() helper function
- [ ] Ensure only post-event ratings allowed
- [ ] Test rating calculations

### Event Management
- [ ] Complete updateEvent() with city/district support
- [ ] Implement deleteEvent()
- [ ] Add authorization checks
- [ ] Add cascade deletion (ratings when event deleted)
- [ ] Test authorization

### Testing
- [ ] Update test-api-simple.js for new endpoints
- [ ] Run full test suite
- [ ] Document results

---

## 🔧 Code Quality Standards

**For all backend work:**

1. **Error Handling**
   - Use ApiError class for all errors
   - Always provide meaningful error messages
   - Return appropriate HTTP status codes

2. **Validation**
   - Validate all input parameters
   - Check authorization before operations
   - Verify data relationships (user-event, event-rating)

3. **Documentation**
   - JSDoc comments for all functions
   - Clear variable names
   - Update README if needed

4. **Testing**
   - Add test cases to test-api-simple.js
   - Test happy path and error cases
   - Verify database changes

5. **Security**
   - Always check user authorization
   - Validate timestamps (event dates)
   - Prevent SQL injection (use Mongoose)

---

## 📅 Daily Breakdown

### Day 1 (Monday)
- 09:00 - 10:00: Backend sprint planning, review test results
- 10:00 - 14:00: Implement joinEvent() + leaveEvent()
- 14:00 - 16:00: Implement getParticipants()
- 16:00 - 17:00: Test & debugging

### Day 2 (Tuesday)
- 09:00 - 11:00: Code review & fixes
- 11:00 - 13:00: Implement Rating system (createRating)
- 13:00 - 14:00: Lunch break
- 14:00 - 17:00: Implement listRatingsByEvent(), recalculate function

### Day 3 (Wednesday)
- 09:00 - 12:00: Implement updateEvent(), deleteEvent()
- 12:00 - 13:00: Authorization testing
- 13:00 - 14:00: Lunch
- 14:00 - 17:00: Full API test suite, bug fixes

### Day 4 (Thursday)
- 09:00 - 10:00: Code review with Abi/Brata
- 10:00 - 14:00: Flutter integration preparation
- 14:00 - 17:00: Document API, handle edge cases

### Day 5 (Friday)
- 09:00 - 12:00: Final testing, performance optimization
- 12:00 - 13:00: Sprint retrospective
- 13:00 - 17:00: Buffer for unexpected issues, documentation

---

## 🎓 Skills Required

### Backend Developer Skills (Week 4)
- ✅ Node.js/Express API development
- ✅ MongoDB operations & queries
- ✅ Authentication & authorization
- ✅ Error handling & validation
- ✅ RESTful API design
- ✅ Data relationship management (joins, references)

### Tools
- Node.js 18+
- MongoDB CLI (for debugging)
- Postman or Insomnia (API testing)
- Git (version control)
- VS Code (editor)

---

## ✅ Definition of Done

**A feature is complete when:**
1. Code is written and passes linting
2. All acceptance criteria met
3. Unit tests pass
4. API tests pass
5. Code reviewed by team
6. Documentation updated
7. No console errors/warnings
8. Deployed to staging (if applicable)

---

## 🚀 Success Metrics

**Week 4 Goals:**
- ✅ Join/Leave events working (100% completion)
- ✅ Rating system working (100% completion)
- ✅ Event management complete (CRUD working)
- ✅ All endpoints tested (100% pass rate)
- ✅ Zero critical bugs
- ✅ Ready for Flutter integration

---

**Backend Development Starts Now!** 💻

Ersya, kamu sekarang positioning sebagai Backend Developer (50%) + PM (50%). 
Fokus implementasi features di atas, jangan hanya coordination.

Next Action: Buka `eventController.js` dan mulai implement `joinEvent()` function! 🔨
