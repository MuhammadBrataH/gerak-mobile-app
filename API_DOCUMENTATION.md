# 📚 GERAK Backend API Documentation
**Status:** MVP Complete & Tested  
**Version:** 1.0.0  
**Base URL:** `http://localhost:5000`  
**Last Updated:** Week 4 Day 2

---

## 🔐 Authentication

### Register User
Create a new user account with email and password.

```bash
curl -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@gerak.test",
    "password": "SecurePass123",
    "name": "John Doe",
    "phone": "+6281234567890",
    "sports": ["futsal", "badminton"],
    "level": "intermediate"
  }'
```

**Request Body:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| email | String | Yes | Must be unique, will be lowercased |
| password | String | Yes | Min 8 chars, must contain letters + numbers |
| name | String | Yes | User display name |
| phone | String | Yes | Phone number with country code |
| sports | Array | No | Sports user plays (futsal, badminton, basketball, tennis, volleyball) |
| level | String | No | Skill level: beginner/intermediate/advanced/mixed (default: beginner) |
| photoUrl | String | No | Profile picture URL |

**Response (201):**
```json
{
  "user": {
    "_id": "60d5ec49c1b4f8a1c4e8f1a2",
    "email": "user@gerak.test",
    "name": "John Doe",
    "phone": "+6281234567890",
    "sports": ["futsal", "badminton"],
    "level": "intermediate",
    "photoUrl": "",
    "createdAt": "2026-04-28T10:00:00.000Z",
    "updatedAt": "2026-04-28T10:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error (409):** Email already registered
```json
{
  "error": "Email is already registered",
  "statusCode": 409
}
```

---

### Login
Authenticate user with email and password.

```bash
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@gerak.test",
    "password": "SecurePass123"
  }'
```

**Response (200):**
```json
{
  "user": { ... },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error (401):** Invalid credentials
```json
{
  "error": "Invalid email or password",
  "statusCode": 401
}
```

---

### Get Current User
Retrieve authenticated user profile.

```bash
curl -X GET http://localhost:5000/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "user": { ... user object ... }
}
```

---

### Logout
Clear user session (server-side token invalidation).

```bash
curl -X POST http://localhost:5000/auth/logout \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

---

### Refresh Token
Get new access token using refresh token.

```bash
curl -X POST http://localhost:5000/auth/refresh \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN"
```

**Response (200):**
```json
{
  "token": "NEW_ACCESS_TOKEN",
  "refreshToken": "NEW_REFRESH_TOKEN"
}
```

---

## 📅 Events

### List Events (Regional Filtering)
Get events with optional filtering by sport, level, city, district, and pagination.

```bash
# Get all events
curl -X GET http://localhost:5000/events

# Filter by city and sport
curl -X GET "http://localhost:5000/events?city=Jakarta&sport=futsal&level=beginner&page=1&limit=10"

# Filter by city and district
curl -X GET "http://localhost:5000/events?city=Jakarta&district=Menteng"
```

**Query Parameters:**
| Parameter | Type | Required | Example | Notes |
|-----------|------|----------|---------|-------|
| city | String | No | Jakarta | Case-insensitive regex match |
| district | String | No | Menteng | Case-insensitive regex match |
| sport | String | No | futsal | Exact match: futsal/badminton/basketball/tennis/volleyball |
| level | String | No | beginner | Exact match: beginner/intermediate/advanced/mixed |
| page | Integer | No | 1 | Pagination page (default: 1) |
| limit | Integer | No | 10 | Results per page (default: 10, max: 100) |

**Response (200):**
```json
{
  "events": [
    {
      "_id": "60d5ec49c1b4f8a1c4e8f1a2",
      "name": "Futsal Malam Senayan",
      "description": "Main futsal santai",
      "sport": "futsal",
      "level": "beginner",
      "startTime": "2026-04-30T19:00:00.000Z",
      "endTime": "2026-04-30T21:00:00.000Z",
      "location": "Lapangan Futsal Senayan",
      "city": "Jakarta",
      "district": "Menteng",
      "maxSlots": 12,
      "joinedUsers": ["user1_id", "user2_id"],
      "adminPhone": "+6287654321098",
      "averageRating": 4.5,
      "reviewCount": 10,
      "createdBy": "organizer_id",
      "createdAt": "2026-04-28T10:00:00.000Z"
    }
  ],
  "total": 42,
  "page": 1
}
```

---

### Create Event
Create a new event (requires authentication).

```bash
curl -X POST http://localhost:5000/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "name": "Futsal Kompetisi",
    "description": "Pertandingan futsal level advanced",
    "sport": "futsal",
    "level": "advanced",
    "startTime": "2026-05-01T19:00:00Z",
    "endTime": "2026-05-01T21:00:00Z",
    "location": "Lapangan Futsal Senayan",
    "city": "Jakarta",
    "district": "Menteng",
    "maxSlots": 16,
    "totalSlots": 16,
    "adminPhone": "+6287654321098",
    "imageUrl": "https://example.com/image.jpg"
  }'
```

**Request Body:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| name | String | Yes | Event name |
| description | String | No | Event description |
| sport | String | Yes | futsal/badminton/basketball/tennis/volleyball |
| level | String | Yes | beginner/intermediate/advanced/mixed |
| startTime | DateTime | Yes | ISO 8601 format |
| endTime | DateTime | Yes | ISO 8601 format |
| location | String | Yes | Venue name/address |
| city | String | Yes | City name (e.g., Jakarta, Bandung) |
| district | String | No | District name (e.g., Menteng, Senayan) |
| maxSlots | Integer | Yes | Maximum participants |
| totalSlots | Integer | Yes | Total available slots |
| adminPhone | String | Yes | Organizer phone with country code |
| imageUrl | String | No | Event cover image URL |
| coordinates | Object | No | {longitude, latitude} for phase 2 GPS (optional) |

**Response (201):**
```json
{
  "event": { ... event object ... }
}
```

---

### Get Event Details
Get single event with participants and ratings.

```bash
curl -X GET http://localhost:5000/events/:eventId
```

**Response (200):**
```json
{
  "event": {
    "_id": "60d5ec49c1b4f8a1c4e8f1a2",
    "name": "Futsal Malam",
    "joinedUsers": [
      {
        "_id": "user1_id",
        "name": "John Doe",
        "email": "john@gerak.test",
        "phone": "+6281234567890",
        "photoUrl": "...",
        "level": "intermediate",
        "sports": ["futsal", "badminton"]
      }
    ],
    "createdBy": {
      "_id": "organizer_id",
      "name": "Organizer Name",
      "email": "organizer@gerak.test",
      "phone": "+6287654321098"
    },
    "averageRating": 4.5,
    "reviewCount": 10,
    ...
  }
}
```

---

### Update Event
Update event details (only event creator).

```bash
curl -X PUT http://localhost:5000/events/:eventId \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "name": "Updated Event Name",
    "description": "Updated description",
    "maxSlots": 20
  }'
```

**Response (200):** Updated event object

**Error (403):** Not authorized
```json
{
  "error": "You are not allowed to update this event",
  "statusCode": 403
}
```

---

### Delete Event
Delete event and associated ratings (only event creator).

```bash
curl -X DELETE http://localhost:5000/events/:eventId \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "message": "Event deleted"
}
```

---

## 👥 Event Participation

### Join Event
Add current user to event participants.

```bash
curl -X POST http://localhost:5000/events/:eventId/join \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "message": "Join successful",
  "event": { ... updated event with joined users ... }
}
```

**Error (409):** Already joined or event full
```json
{
  "error": "You already joined this event",
  "statusCode": 409
}
```

or

```json
{
  "error": "Event is already full",
  "statusCode": 409
}
```

---

### Leave Event
Remove current user from event participants.

```bash
curl -X POST http://localhost:5000/events/:eventId/leave \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "message": "Leave successful",
  "event": { ... updated event without user ... }
}
```

---

### Get Participants
List all participants in an event.

```bash
curl -X GET http://localhost:5000/events/:eventId/participants
```

**Response (200):**
```json
{
  "participants": [
    {
      "_id": "user1_id",
      "name": "John Doe",
      "email": "john@gerak.test",
      "phone": "+6281234567890",
      "photoUrl": "...",
      "level": "intermediate",
      "sports": ["futsal"]
    }
  ]
}
```

---

## ⭐ Ratings & Reviews

### Create Rating
Rate an event (only after event ends, only for participants).

```bash
curl -X POST http://localhost:5000/ratings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "eventId": "60d5ec49c1b4f8a1c4e8f1a2",
    "score": 5,
    "review": "Great event! Well organized and fun atmosphere."
  }'
```

**Request Body:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| eventId | String | Yes | Event to rate |
| score | Integer | Yes | Rating score 1-5 |
| review | String | No | Review text |

**Validation Rules:**
- ✅ Score must be 1-5 (integer only)
- ✅ Event must have ended
- ✅ User must have joined the event
- ✅ Can only rate once per event

**Response (201):**
```json
{
  "rating": {
    "_id": "60d5ec49c1b4f8a1c4e8f1a3",
    "eventId": "60d5ec49c1b4f8a1c4e8f1a2",
    "userId": "user1_id",
    "score": 5,
    "review": "Great event!",
    "createdAt": "2026-04-30T21:30:00.000Z",
    "updatedAt": "2026-04-30T21:30:00.000Z"
  }
}
```

**Error (400):** Invalid score
```json
{
  "error": "Score must be an integer between 1 and 5",
  "statusCode": 400
}
```

**Error (403):** Not a participant
```json
{
  "error": "You can only rate events you have joined",
  "statusCode": 403
}
```

**Error (409):** Already rated
```json
{
  "error": "You already rated this event. Use PUT to update it.",
  "statusCode": 409
}
```

---

### List Ratings for Event
Get all ratings and reviews for an event.

```bash
curl -X GET "http://localhost:5000/ratings/event/:eventId?page=1&limit=10"
```

**Response (200):**
```json
{
  "ratings": [
    {
      "_id": "60d5ec49c1b4f8a1c4e8f1a3",
      "eventId": "60d5ec49c1b4f8a1c4e8f1a2",
      "userId": {
        "_id": "user1_id",
        "name": "John Doe",
        "email": "john@gerak.test",
        "photoUrl": "..."
      },
      "score": 5,
      "review": "Great event!",
      "createdAt": "2026-04-30T21:30:00.000Z"
    }
  ],
  "total": 10
}
```

---

### List User's Ratings
Get all ratings created by a user.

```bash
curl -X GET http://localhost:5000/ratings/user/:userId
```

**Response (200):**
```json
{
  "ratings": [
    {
      "_id": "60d5ec49c1b4f8a1c4e8f1a3",
      "eventId": {
        "_id": "60d5ec49c1b4f8a1c4e8f1a2",
        "name": "Futsal Malam",
        "sport": "futsal",
        "location": "Lapangan Senayan",
        "startTime": "2026-04-30T19:00:00.000Z",
        "endTime": "2026-04-30T21:00:00.000Z"
      },
      "score": 5,
      "review": "Great event!",
      "createdAt": "2026-04-30T21:30:00.000Z"
    }
  ]
}
```

---

### Update Rating
Update rating score and/or review (only rating creator).

```bash
curl -X PUT http://localhost:5000/ratings/:ratingId \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "score": 4,
    "review": "Updated review text"
  }'
```

**Response (200):** Updated rating object

---

### Delete Rating
Remove a rating (only rating creator).

```bash
curl -X DELETE http://localhost:5000/ratings/:ratingId \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200):**
```json
{
  "message": "Rating deleted"
}
```

---

## 🔄 Error Codes Reference

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 400 | Bad Request | Invalid parameters, missing required fields, validation failed |
| 401 | Unauthorized | Invalid or missing authentication token |
| 403 | Forbidden | User not authorized for this action (e.g., not event creator) |
| 404 | Not Found | Resource not found (event, user, rating) |
| 409 | Conflict | Resource conflict (duplicate email, already joined, already rated) |
| 500 | Server Error | Unexpected server error |

---

## 📋 Response Format

All successful responses follow this format:
```json
{
  "field": "value",
  "data": [...] // for list endpoints
}
```

All error responses follow this format:
```json
{
  "error": "Error description",
  "statusCode": 400
}
```

---

## 🔑 Authentication Header Format

Include JWT token in Authorization header:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Token expiry:
- **Access Token:** 24 hours
- **Refresh Token:** 7 days

---

## 📊 Data Models

### User
```javascript
{
  _id: ObjectId,
  email: String (unique),
  name: String,
  phone: String,
  sports: [String], // futsal, badminton, basketball, tennis, volleyball
  level: String, // beginner, intermediate, advanced, mixed
  photoUrl: String,
  refreshTokenHash: String,
  createdAt: DateTime,
  updatedAt: DateTime
}
```

### Event
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  sport: String, // futsal, badminton, basketball, tennis, volleyball
  level: String, // beginner, intermediate, advanced, mixed
  startTime: DateTime,
  endTime: DateTime,
  location: String,
  city: String (indexed),
  district: String (indexed),
  coordinates: {
    type: "Point",
    coordinates: [longitude, latitude] // Optional for phase 2
  },
  maxSlots: Number,
  totalSlots: Number,
  joinedUsers: [ObjectId], // References to User
  adminPhone: String,
  imageUrl: String,
  averageRating: Number (0-5),
  reviewCount: Number,
  createdBy: ObjectId, // Reference to User
  createdAt: DateTime,
  updatedAt: DateTime
}
```

### Rating
```javascript
{
  _id: ObjectId,
  eventId: ObjectId, // Reference to Event
  userId: ObjectId, // Reference to User
  score: Number, // 1-5
  review: String,
  createdAt: DateTime,
  updatedAt: DateTime
}
```

---

## 🧪 Testing

Run comprehensive test suite:
```bash
cd backend
node test-api-simple.js
```

Clear database before testing:
```bash
node clear-db.js
```

**Current Test Results:**
- ✅ 100% Pass Rate (21/21 tests)
- ✅ Auth: 5/5 tests
- ✅ Events: 7/7 tests
- ✅ Participation: 4/4 tests
- ✅ Ratings: 5/5 tests

---

## 🚀 Ready for Flutter Integration

All endpoints are production-ready for Flutter frontend implementation:
- ✅ Authentication (register/login/logout/refresh)
- ✅ Event CRUD with regional filtering
- ✅ Event participation (join/leave)
- ✅ Rating system with validation
- ✅ Comprehensive error handling

**Next Steps for Frontend:**
1. Implement auth token storage & refresh logic
2. Build event listing screen with city/district filters
3. Implement event detail & participation UI
4. Add rating submission form
5. Handle API error responses

---

*Generated: Week 4, Day 2*  
*Status: MVP Complete, Tested, & Documented*
