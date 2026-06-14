# WaitSafe 🛡️📱

### Proactive Journey Monitoring and Emergency Response Platform

WaitSafe is a production-grade, cross-platform personal safety application designed to provide real-time journey monitoring, automated geofencing, and instant emergency alert dispatch. The system combines a highly responsive Flutter frontend with a robust FastAPI backend to create a secure and scalable ecosystem for personal safety.

The application enables users to:

* Track live geographic movement during travel.
* Define expected destinations and estimated arrival times.
* Automatically detect deviations from predefined routes or time thresholds.
* Trigger panic alerts manually via an emergency button.
* Notify trusted contacts through automated SMS messages containing live location data.

---

## 🎯 Project Vision

WaitSafe transforms personal safety from a reactive process into a proactive protection system.

Unlike traditional safety applications that depend entirely on manual SOS activation, WaitSafe continuously monitors journeys, validates expected arrival times, detects route deviations, and automatically alerts trusted contacts when potential risks are identified.

---

## 💡 Why WaitSafe?

Most existing safety applications activate only after a user manually requests help.

In real emergency situations:

* Users may be unable to unlock their phone.
* Victims may not have time to trigger an SOS alert.
* Families remain unaware until it is too late.
* Emergency response is delayed.

WaitSafe introduces a proactive safety model by monitoring journeys in real time and detecting risk conditions before emergencies escalate.

---

## 🌟 Key Features

### 📍 Real-Time GPS Tracking

Continuously streams device coordinates using hardware-level GPS integration.

### 🗺️ Intelligent Geofencing

Automatically computes safe zones and detects route deviations.

### ⏱️ ETA Monitoring

Compares actual travel progress against expected arrival times.

### 🚨 Panic Button

Allows users to instantly send emergency alerts with current coordinates.

### 📩 Automated SMS Dispatch

Uses Twilio integration to send real-time emergency notifications.

### 🔐 Secure Authentication

Implements JWT-based user authentication and Argon2 password hashing.

### 💾 Local Persistence

Stores preferences and session data using Shared Preferences.

### 🌐 Cross-Platform Deployment

Runs seamlessly on Android, Web, and Desktop platforms.

### 🎨 User-Centric Emergency Interface

Designed for clarity and accessibility during stressful situations, ensuring rapid interaction and visibility when it matters most.

---

## 🚀 Innovation Highlights

* Proactive safety monitoring instead of reactive SOS-only systems.
* Journey time validation using expected arrival estimates.
* Automatic route deviation detection through geofencing.
* Instant emergency communication with trusted contacts.
* Real-time location sharing during critical situations.
* Scalable architecture suitable for smart-city safety ecosystems.

---

## ✅ Current MVP Capabilities

Implemented Features:

* User Authentication
* Live GPS Tracking
* Destination & ETA Setup
* Geofencing Logic
* Panic SOS Alerts
* Trusted Contact Management
* SMS Notification System
* Cross-Platform Flutter Application

---

## 🏗️ System Architecture

```text
┌───────────────────────────────────────────────────────────────────────┐
│                         WaitSafe Frontend Client                     │
│      Flutter + Provider + Geolocator + Shared Preferences            │
└───────────────────────────────┬───────────────────────────────────────┘
                                │
                                ▼
                        Asynchronous HTTP REST
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         WaitSafe Backend API                         │
│        FastAPI + SQLAlchemy + Pydantic + JWT + Twilio                │
└───────────────────────────────┬───────────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                          PostgreSQL Database                         │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

### Frontend Technologies

* **Core Language:** Dart 3.x
* **UI Framework:** Flutter SDK
* **State Management:** Provider (^6.1.5+1)
* **Local Persistence:** Shared Preferences (^2.5.5)
* **Networking:** HTTP REST Client (^1.2.1)
* **Geolocation:** Geolocator (^14.0.2)
* **Animations:** Lottie (^3.1.2)

### Backend Technologies

* **Core Framework:** FastAPI (Python 3.12+)
* **ASGI Server:** Uvicorn
* **ORM:** SQLAlchemy (Asynchronous)
* **Validation:** Pydantic v2
* **Password Security:** Passlib with Argon2
* **Authentication:** Python-Jose (JWT)
* **Communication Services:** Twilio REST SDK

### Database

* PostgreSQL

---

## 🎨 Frontend Architecture

The Flutter frontend follows a reactive state-driven architecture where user interactions trigger state updates, local persistence, and asynchronous communication with the backend.

```text
[User Interaction UI]
         │
         ▼
[Provider State Layer] ──(Persists Cache)──► [Shared Preferences (Local)]
         │
         ▼ (Asynchronous HTTP Payload)
[Networking Client]
         │
         ▼ (REST API Handshake)
[WaitSafe Backend Service]
```

### UI / UX Engineering

* Neon pink glow accents on ultra-dark backgrounds
* Glassmorphism-inspired cards and panels
* Linear gradients and custom shadow systems
* Fully responsive layouts for Web, Android, and Desktop
* High-visibility design optimized for emergency scenarios

### Core Flutter Widgets Used

* `Scaffold`
* `AppBar`
* `SafeArea`
* `SingleChildScrollView`
* `Scrollbar`
* `Container`
* `Row`
* `Column`
* `Expanded`
* `ConstrainedBox`
* `TextField`
* `SwitchListTile`
* `ElevatedButton`
* `SnackBar`
* `ListTile`
* `CircleAvatar`

---

## ⚙️ Backend Architecture

The FastAPI backend acts as a stateless transactional engine that validates requests, authenticates users, performs geofencing computations, and dispatches emergency alerts.

```text
[Mobile Frontend Client]
          │
          ▼ (HTTP Requests / Telemetry Stream)
[Uvicorn ASGI Gateway]
          │
          ▼
[FastAPI Engine Layer]
          │
          ▼
[SQLAlchemy ORM (Async)]
          │
          ▼
[PostgreSQL Database]
```

### Backend Responsibilities

* CORS validation
* Request schema validation using Pydantic
* JWT bearer token authentication
* Argon2 password hashing
* Asynchronous database session management
* Automated geofencing calculations
* Real-time location processing
* Panic event routing
* Twilio SMS alert dispatch

---

## 🔐 Security Features

* Argon2 password hashing
* JWT-based authentication and authorization
* Secure bearer token workflows
* Protected emergency endpoints
* Input validation with Pydantic schemas

---

## 📡 Emergency Alert Workflow

```text
1. User presses Panic Button
2. Frontend retrieves current GPS coordinates
3. Coordinates are sent to FastAPI backend
4. Backend validates JWT and request schema
5. Twilio API sends SMS alerts to trusted contacts
6. Contacts receive emergency message with live location
```

---

## 🌍 Supported Platforms

* Android
* Web (Chrome, Edge, Firefox)
* Windows Desktop
* macOS Desktop
* Linux Desktop

---

## 🎥 Demo

Prototype Status: Functional MVP

The current implementation demonstrates real-time location tracking, geofencing, ETA monitoring, emergency alert generation, and SMS notification workflows.

---

## 🚀 Future Enhancements

* AI-based route anomaly detection
* Push notifications
* Live contact tracking dashboard
* Voice-activated SOS
* Wearable device integration
* Offline emergency queueing

---

## 👥 Team

### Team WaitSafe

* Niranjan J Menon
* Atmihaa M B

Hackathon Project | Prototype Development Round

---

## 📄 License

This project is intended for academic and research purposes. Licensing terms may be added upon open-source publication.
