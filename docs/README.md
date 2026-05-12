# 📚 GERAK Mobile App - Documentation Index

Welcome to the GERAK project documentation!

---

## 📖 Documentation Structure

### 🏗️ [Architecture](./architecture/PROJECT_ARCHITECTURE.md)

- Project structure overview
- Clean architecture pattern
- Feature-based organization
- Best practices & guidelines

### 📚 [Documentation](./documentation/)

- **[API_DOCUMENTATION.md](./documentation/API_DOCUMENTATION.md)** - Complete backend API reference
- **[BACKEND_EXPLANATION.md](./documentation/BACKEND_EXPLANATION.md)** - Detailed backend architecture explanation
- **[BACKEND_RINGKASAN.md](./documentation/BACKEND_RINGKASAN.md)** - Backend summary in Indonesian

### ⚠️ [Deprecated](./deprecated/)

- **[README.md](./deprecated/README.md)** - Information about deprecated Locofy auto-generated files
- **[locofy_autogen/](./deprecated/locofy_autogen/)** - Original Locofy-generated code (DO NOT USE)

---

## 🚀 Quick Start

### For New Developers

1. Read [PROJECT_ARCHITECTURE.md](./architecture/PROJECT_ARCHITECTURE.md) first
2. Understand the feature-based structure
3. Review the specific feature you'll be working on
4. Check [API_DOCUMENTATION.md](./documentation/API_DOCUMENTATION.md) for backend integration

### For Backend Integration

1. Review [API_DOCUMENTATION.md](./documentation/API_DOCUMENTATION.md)
2. Check [BACKEND_EXPLANATION.md](./documentation/BACKEND_EXPLANATION.md) for detailed implementation
3. Reference [BACKEND_RINGKASAN.md](./documentation/BACKEND_RINGKASAN.md) for quick overview

---

## 📁 Current Project Status

✅ **Completed:**

- Feature-based architecture setup
- All presentation layers (screens)
- Navigation system with GetX
- Theme & design system
- Profile dropdown menu (login/logout UI)
- Search functionality
- Activity detail page
- API documentation

🔄 **In Progress:**

- Backend API integration
- Data layer implementation

---

## 🎯 Key Features

### Authentication

- User login/logout
- Session management
- Profile dropdown menu

### Events/Activities

- Search activities by title/location/category
- Activity detail page with:
  - Event image
  - Organizer info
  - Description
  - Date & time
  - Location with map
  - Participants list
  - Join button

### Community

- Community listing
- Profile management

### UI/UX

- Consistent design system
- Responsive layouts
- Smooth navigation

---

## 🛠️ Technology Stack

- **Framework:** Flutter 3.0+
- **State Management:** GetX
- **Navigation:** GetX Routes
- **Backend:** Node.js + Express (in /backend folder)
- **Database:** MongoDB
- **Authentication:** JWT
- **Design Tool:** Figma

---

## 📞 Support

For questions about specific areas:

- **Architecture:** See [PROJECT_ARCHITECTURE.md](./architecture/PROJECT_ARCHITECTURE.md)
- **Features:** Check corresponding feature folder in `lib/features/`
- **Backend API:** Reference [API_DOCUMENTATION.md](./documentation/API_DOCUMENTATION.md)

---

_Last Updated: 2026-05-12_
