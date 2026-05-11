from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.models.database import SessionLocal, UserLocation, User
from app.models.schemas import LocationCreate, LocationResponse
from app.api.contacts import get_current_user 

router = APIRouter(prefix="/location", tags=["Location Tracking"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 1. UPDATE LOCATION (The "Ping")
@router.post("/", response_model=LocationResponse)
def update_location(
    location: LocationCreate, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    """
    This endpoint acts as the receiver for the 'Live' heartbeat.
    The mobile app will call this every X seconds/minutes.
    """
    new_location = UserLocation(
        latitude=location.latitude,
        longitude=location.longitude,
        user_id=current_user.id
    )
    db.add(new_location)
    db.commit()
    db.refresh(new_location)
    return new_location

# 2. GET HISTORY (The "Trail")
@router.get("/history", response_model=List[LocationResponse])
def get_location_history(
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    """
    Returns all recorded locations for the logged-in user, 
    sorted from most recent to oldest.
    """
    locations = db.query(UserLocation)\
                  .filter(UserLocation.user_id == current_user.id)\
                  .order_by(UserLocation.timestamp.desc())\
                  .all()
    return locations