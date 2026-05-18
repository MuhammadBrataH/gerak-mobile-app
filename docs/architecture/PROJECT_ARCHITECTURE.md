# 🏗️ GERAK Mobile App - Project Architecture

**Version:** 1.0.0  
**Updated:** 2026-05-12  
**Architecture Pattern:** Clean Architecture + Domain-Driven Design

---

## 📋 Project Structure

```
gerak-mobile-app/
├── docs/                          # 📚 Documentation
│   ├── architecture/              # Architecture patterns & decisions
│   ├── documentation/             # API docs, backend explanation
│   └── deprecated/                # Old/unused code (locofy)
│
├── lib/                           # 📱 Flutter Application Source
│   │
│   ├── core/                      # Core utilities & configuration
│   │   ├── constants/             # App-wide constants
│   │   ├── network/               # HTTP client, interceptors
│   │   ├── routes/                # Navigation & route definitions
│   │   ├── theme/                 # Colors, typography, theme
│   │   └── utils/                 # Helper functions, extensions
│   │
│   ├── features/                  # Feature modules (Clean Architecture)
│   │   ├── auth/                  # Authentication feature
│   │   │   ├── data/              # API calls, repositories (currently empty)
│   │   │   └── presentation/
│   │   │       ├── controllers/   # GetX controllers, business logic
│   │   │       └── pages/         # Auth screens (login, signup, etc)
│   │   │
│   │   ├── events/                # Events/Activities feature
│   │   │   ├── data/              # API calls, repositories (currently empty)
│   │   │   └── presentation/
│   │   │       └── pages/         # Dashboard, event detail, activity screens
│   │   │
│   │   ├── community/             # Community feature
│   │   │   ├── data/              # API calls, repositories (currently empty)
│   │   │   └── presentation/
│   │   │       └── pages/         # Community screens
│   │   │
│   │   ├── profile/               # User profile feature
│   │   │   ├── data/              # API calls, repositories (currently empty)
│   │   │   └── presentation/
│   │   │       └── pages/         # Profile screens
│   │   │
│   │   └── geofencing/            # Geofencing feature (Phase 2)
│   │       ├── data/
│   │       └── presentation/
│   │
│   ├── shared/                    # Shared resources across features
│   │   └── widgets/               # Reusable widgets, components
│   │
│   └── main.dart                  # App entry point
│
├── android/                       # Android-specific code
├── ios/                           # iOS-specific code
├── web/                           # Web support
├── test/                          # Unit & widget tests
├── assets/                        # Images, fonts, etc
│
├── analysis_options.yaml          # Dart linting rules
├── pubspec.yaml                   # Dependencies & metadata
├── .gitignore                     # Git ignore rules
└── README.md                      # Project overview

```

---

## 🎯 Architecture Pattern

### Clean Architecture Principles

```
                    Presentation Layer
                         ↓
                    Business Logic Layer
                         ↓
                    Data/Repository Layer
                         ↓
                    Data Source Layer
```

### Implementation Structure

**Feature-Based Organization:**

```
feature/
├── data/                    # Data layer (repositories, models, API)
│   ├── datasources/         # API calls, local storage
│   ├── models/              # Data classes, serialization
│   └── repositories/        # Concrete repository implementations
│
├── presentation/            # Presentation layer (UI, controllers)
│   ├── controllers/         # GetX controllers, state management
│   └── pages/               # UI screens, widgets
│
└── domain/                  # Domain layer (entities, use cases)
    ├── entities/            # Core business objects
    └── usecases/            # Business logic operations
```

---

## 📦 Current Implementation Status

### ✅ Completed Layers

- **Presentation Layer** - All screens implemented with GetX
  - auth (login, signup, onboarding)
  - events (dashboard, activity detail, search)
  - community (community listing)
  - profile (user profile)

- **Routing** - Centralized route management in `lib/core/routes/`

- **Theme & Constants** - Colors, typography, app-wide constants

### 🔄 In Progress / Future

- **Data Layer** - API integration when backend is fully connected
- **Domain Layer** - Business logic entities and use cases
- **State Management** - GetX bindings setup for each feature
- **Testing** - Unit tests, widget tests, integration tests

---

## 🔀 Navigation Architecture

Using **GetX** for navigation:

```dart
// Define routes in core/routes/app_routes.dart
static const String home = '/home';
static const String login = '/login';
static const String activityDetail = '/activity/detail';

// Navigate
Get.toNamed(AppRoutes.home);
Get.offAllNamed(AppRoutes.login);

// With parameters
Get.toNamed(AppRoutes.activityDetail, arguments: {...});
```

---

## 🎨 Design System

### Colors

- **Primary:** `#2563EB` (Blue)
- **Dark Text:** `#0F172A`
- **Light Background:** `#E0F2FE`

### Typography

- **Headings:** Lexend font
- **Body:** Plus Jakarta Sans font

### Components

- Shared widgets in `lib/shared/widgets/`
- Reusable UI components across features

---

## 📌 Best Practices

### 1. Feature Independence

- Each feature should be self-contained
- Minimize cross-feature dependencies
- Use dependency injection (GetX bindings)

### 2. Code Organization

- One feature per folder
- Clear separation of concerns
- Consistent naming conventions

### 3. State Management

- Use GetX controllers for state
- Keep controllers lightweight
- Avoid business logic in widgets

### 4. Navigation

- Centralize routes in `core/routes/`
- Use named routes, not direct widget instantiation
- Pass data via `arguments` parameter

### 5. Error Handling

- Implement try-catch in controllers
- Show user-friendly error messages
- Log errors for debugging

---

## 🚀 Future Improvements

1. **Data Layer Implementation**
   - Create repositories for API calls
   - Implement data models and serialization
   - Add local caching with Hive/SQLite

2. **Domain Layer**
   - Define entities for business objects
   - Create use cases for business logic
   - Implement repository interfaces

3. **Testing**
   - Unit tests for controllers
   - Widget tests for UI screens
   - Integration tests for full flows

4. **Performance**
   - Lazy loading for screens
   - Image caching
   - Pagination for lists

5. **Advanced Features**
   - Real-time notifications
   - Offline support
   - Analytics tracking

---

## 🔗 Related Files

- Navigation: `lib/core/routes/app_routes.dart`
- Theme: `lib/core/theme/`
- Constants: `lib/core/constants/`
- API Integration: Future in `lib/core/network/`

---

_Document maintained by: Development Team_  
_Last updated: 2026-05-12_
