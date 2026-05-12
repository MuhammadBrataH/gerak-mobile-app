# 📚 Backend GERAK - Penjelasan Lengkap Apa Yang Dikerjakan

**Status:** ✅ SELESAI & PRODUCTION READY  
**Tanggal:** 5 Mei 2026 (Week 4-5)  
**Developer:** Ersya  
**Branch:** Ersya  
**Test Pass Rate:** 100% (21/21 tests) ✅

---

## 🎯 Ringkasan Singkat

Backend GERAK adalah **RESTful API server** yang dibangun dengan **Node.js + Express** untuk aplikasi mobile olahraga. Backend ini menyediakan semua API yang diperlukan Flutter frontend untuk:

- ✅ Registrasi & Login pengguna
- ✅ Membuat & mengelola event olahraga
- ✅ Sistem regional (filter by kota/kabupaten)
- ✅ Join/leave event olahraga
- ✅ Rating & review event

**Teknologi Stack:**

- **Runtime:** Node.js (JavaScript)
- **Web Framework:** Express.js
- **Database:** MongoDB (NoSQL)
- **Authentication:** JWT (JSON Web Tokens)
- **Password Security:** bcryptjs (hashing)

---

## 🏗️ Arsitektur Backend

```
GERAK Backend (MVC Architecture)
│
├── Controllers (Business Logic)
│   ├── authController.js      → Logika register/login
│   ├── eventController.js     → Logika event CRUD
│   └── ratingController.js    → Logika rating/review
│
├── Models (Database Schema)
│   ├── User.js                → Struktur data user
│   ├── Event.js               → Struktur data event
│   └── Rating.js              → Struktur data rating
│
├── Routes (API Endpoints)
│   ├── authRoutes.js          → /auth/* endpoints
│   ├── eventRoutes.js         → /events/* endpoints
│   └── ratingRoutes.js        → /ratings/* endpoints
│
├── Middleware (Processing)
│   ├── auth.js                → JWT verification
│   └── errorHandler.js        → Error handling
│
├── Utilities (Helper Functions)
│   ├── validators.js          → Input validation
│   ├── helpers.js             → Helper functions
│   ├── constants.js           → App constants
│   ├── asyncHandler.js        → Async wrapper
│   └── tokens.js              → Token management
│
└── Config & Server
    ├── app.js                 → Express setup
    ├── server.js              → Server entry point
    └── config/db.js           → MongoDB connection
```

---

## 🔧 Komponen Utama

### 1. **AUTHENTICATION SYSTEM** 🔐

**File:** `src/controllers/authController.js`

**Fitur:**

- ✅ User Registration dengan validasi password
- ✅ User Login dengan JWT token
- ✅ Refresh token untuk session panjang
- ✅ Get current user info
- ✅ Logout

**Security:**

- Password di-hash dengan bcryptjs (12 rounds)
- Minimum password: 8 karakter + letters + numbers
- JWT token: 24 jam expiry (access token)
- Refresh token: 7 hari expiry
- Email unique di database

---

_Generated: Week 4-5, Day 2_  
_Status: MVP Complete, Tested, & Documented_
