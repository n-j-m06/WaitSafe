# WaitSafe Backend ⚙️

### Secure API Infrastructure for Real-Time Safety Monitoring

The WaitSafe Backend is built using **FastAPI** and serves as the core processing engine of the WaitSafe ecosystem. It manages user authentication, journey monitoring, geofencing logic, emergency workflows, and automated SMS alert dispatch.

Designed with scalability, security, and performance in mind, the backend enables seamless communication between the frontend application, database, and external services.

---

## 🚀 Core Responsibilities

### 🔐 Authentication & Authorization

* JWT-based user authentication
* Secure session management
* Protected API endpoints
* Argon2 password hashing

### 📍 Journey Monitoring

* Real-time location processing
* Destination and ETA validation
* Route monitoring workflows
* Travel status management

### 🗺️ Geofencing Engine

* Safe-zone validation
* Route deviation detection
* Location-based event handling

### 🚨 Emergency Management

* Panic alert processing
* Emergency event generation
* Trusted contact notification workflows

### 📩 SMS Communication

* Twilio-powered SMS delivery
* Emergency alert dispatch
* Location-enabled notifications

---

## 🏗️ Backend Architecture

```text
Client Application
        │
        ▼
 FastAPI REST API
        │
 ┌──────┴──────┐
 ▼             ▼
Authentication  Journey Engine
(JWT)           (Tracking & Geofencing)
        │
        ▼
 PostgreSQL Database
        │
        ▼
 Twilio SMS Service
        │
        ▼
 Trusted Contacts
```

---

## 🛠️ Technology Stack

### Framework

* FastAPI

### Language

* Python 3.12+

### Database

* PostgreSQL

### ORM

* SQLAlchemy (Async)

### Authentication

* JWT (Python-Jose)

### Validation

* Pydantic v2

### Security

* Passlib
* Argon2

### Communication Services

* Twilio REST SDK

### Server

* Uvicorn

---

## 📂 API Capabilities

* User Registration
* User Login
* JWT Token Generation
* Journey Creation
* Location Tracking
* ETA Monitoring
* Geofencing Validation
* Panic Alert Triggering
* Trusted Contact Management
* Emergency SMS Dispatch

---

## 🔐 Security Features

* Argon2 Password Hashing
* JWT Authentication
* Request Validation using Pydantic
* Protected Routes
* Secure API Communication

---

## ⚡ Setup & Installation

### Clone Repository

```bash
git clone <repository-url>
cd backend
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Configure Environment Variables

Create a `.env` file:

```env
DATABASE_URL=<postgresql_connection_string>

SECRET_KEY=<jwt_secret>

TWILIO_ACCOUNT_SID=<twilio_sid>

TWILIO_AUTH_TOKEN=<twilio_token>

TWILIO_PHONE_NUMBER=<twilio_phone>
```

### Run Development Server

```bash
uvicorn app.main:app --reload
```

Server:

```text
http://localhost:8000
```

API Documentation:

```text
http://localhost:8000/docs
```

---

## 🎯 Project Goal

The WaitSafe backend is designed to support proactive personal safety by continuously processing journey data, validating travel behavior, and enabling rapid emergency communication when assistance may be required.

---

## 👨‍💻 Contributors

* Niranjan J Menon
* Atmihaa M B

Part of the WaitSafe Project 🛡️
