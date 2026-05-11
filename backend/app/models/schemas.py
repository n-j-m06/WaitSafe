from pydantic import BaseModel, Field
from typing import List, Optional

# --- USER SCHEMAS ---
class UserCreate(BaseModel):
    username: str
    # This Field(...) ensures the 72-byte limit is never exceeded
    password: str = Field(..., max_length=72)

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