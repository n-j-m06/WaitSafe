from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

# --- USER SCHEMAS ---
class UserCreate(BaseModel):
    username: str
    password: str = Field(..., max_length=72)  # Limits input to Bcrypt's max

class UserResponse(BaseModel):
    id: int
    username: str
    class Config:
        from_attributes = True

# --- EMERGENCY CONTACT SCHEMAS ---
class ContactCreate(BaseModel):
    name: str
    phone: str

class ContactResponse(BaseModel):
    id: int
    name: str
    phone: str
    user_id: int
    class Config:
        from_attributes = True

# --- LOCATION SCHEMAS ---
class LocationCreate(BaseModel):
    latitude: float
    longitude: float

class LocationResponse(BaseModel):
    id: int
    latitude: float
    longitude: float
    timestamp: datetime
    user_id: int
    class Config:
        from_attributes = True

# --- SAFE ZONE SCHEMAS ---
class SafeZoneCreate(BaseModel):
    name: str
    latitude: float
    longitude: float
    radius_meters: float

class SafeZoneResponse(BaseModel):
    id: int
    name: str
    latitude: float
    longitude: float
    radius_meters: float
    user_id: int
    class Config:
        from_attributes = True

# --- ALERT SCHEMAS ---
class PanicAlertResponse(BaseModel):
    message: str
    last_location: LocationResponse
    contacts_notified: List[ContactResponse]
    class Config:
        from_attributes = True