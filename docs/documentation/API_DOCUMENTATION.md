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

## 🔄 Error Codes Reference

| Code | Meaning      | Common Causes                                                      |
| ---- | ------------ | ------------------------------------------------------------------ |
| 400  | Bad Request  | Invalid parameters, missing required fields, validation failed     |
| 401  | Unauthorized | Invalid or missing authentication token                            |
| 403  | Forbidden    | User not authorized for this action (e.g., not event creator)      |
| 404  | Not Found    | Resource not found (event, user, rating)                           |
| 409  | Conflict     | Resource conflict (duplicate email, already joined, already rated) |
| 500  | Server Error | Unexpected server error                                            |

---

_Generated: Week 4, Day 2_  
_Status: MVP Complete, Tested, & Documented_
