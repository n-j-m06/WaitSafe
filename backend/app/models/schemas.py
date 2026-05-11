from pydantic import BaseModel
from typing import List, Optional

# This is what the Frontend must send to Create a User
class UserCreate(BaseModel):
    username: str
    password: str

# This is what the API will send back to the Frontend (No password included!)
class UserResponse(BaseModel):
    id: int
    username: str

    class Config:
        from_attributes = True # This tells Pydantic to work with SQLAlchemy