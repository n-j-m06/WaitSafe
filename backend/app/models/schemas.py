from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class UserCreate(BaseModel):
    username: str
    password: str = Field(..., max_length=72)

class UserResponse(BaseModel):
    id: int
    username: str
    class Config:
        from_attributes = True

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