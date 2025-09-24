# Temple & Pilgrimage Crowd Management System - Architecture

## Overview
Modern mobile-first application for managing crowds at pilgrimage sites (Somnath, Dwarka, Ambaji, Pavagadh) with culturally themed UI and dual interfaces for pilgrims and administrators.

## Core Features (MVP)
1. **Home Dashboard** - Welcome banner with live crowd density, quick access buttons
2. **Darshan Booking** - Virtual queue management with QR codes and real-time updates
3. **Traffic & Parking** - Map-based parking availability and navigation guidance
4. **Admin Analytics** - Crowd prediction dashboard with heatmaps and staff deployment
5. **Emergency SOS** - Large panic button with immediate response routing
6. **Lost & Found** - Report system with admin broadcast capabilities
7. **Pilgrim Info Hub** - Temple timings, facilities, multilingual content

## Technical Architecture

### Data Models
- `Temple` - Temple information and current status
- `DarshanBooking` - Queue management and time slots
- `CrowdData` - Real-time density and predictions
- `Emergency` - SOS events and responses
- `LostFoundItem` - Missing person/item reports
- `User` - Pilgrim/admin profiles

### Screen Structure
```
Main App
├── Home Screen (Dashboard)
├── Darshan Booking Flow
│   ├── Temple Selection
│   ├── Time Slot Selection
│   └── QR Code Display
├── Traffic & Parking Map
├── Admin Dashboard
│   ├── Crowd Analytics
│   ├── Staff Deployment
│   └── Emergency Management
├── Emergency SOS
├── Lost & Found
└── Pilgrim Information
```

### Key Components
- `HomeScreen` - Main dashboard with quick actions
- `DarshanBookingWidget` - Complete booking flow
- `CrowdHeatMap` - Visual density representation
- `EmergencyButton` - Large, prominent SOS functionality
- `AdminDashboard` - Analytics and management tools
- `LanguageSwitcher` - Hindi/English/Gujarati support

### Color Palette (Sacred Theme)
- Primary (Sacred Saffron): #FF9933
- Highlight (Marigold Gold): #FFC000
- Critical (Vermilion Red): #D22B2B
- Background (Temple Cream): #FFF8E1
- Text (Charcoal): #333333

## Implementation Priority
1. Update theme with cultural colors
2. Create data models and mock data
3. Build home dashboard with crowd indicators
4. Implement darshan booking flow
5. Add emergency and lost/found features
6. Create admin dashboard with analytics
7. Add multilingual support
8. Final testing and compilation

## File Structure (10-12 files total)
- `main.dart` - App entry point
- `theme.dart` - Cultural color scheme
- `models/` - Data structures
- `screens/home_screen.dart`
- `screens/darshan_booking_screen.dart`
- `screens/admin_dashboard.dart`
- `screens/emergency_screen.dart`
- `screens/lost_found_screen.dart`
- `screens/pilgrim_info_screen.dart`
- `widgets/` - Reusable components
- `services/mock_data_service.dart`