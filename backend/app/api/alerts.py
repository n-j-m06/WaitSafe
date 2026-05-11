from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.models.database import SessionLocal, User, UserLocation, EmergencyContact
from app.models.schemas import PanicAlertResponse
from app.api.contacts import get_current_user 

router = APIRouter(prefix="/alerts", tags=["Emergency Alerts"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/panic", response_model=PanicAlertResponse)
def trigger_panic_button(
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    """
    Final Verification Logic:
    1. Grabs latest location.
    2. Gathers all user contacts.
    3. Formats a clickable Google Maps link.
    """
    
    # Fetch latest location
    latest_location = db.query(UserLocation)\
        .filter(UserLocation.user_id == current_user.id)\
        .order_by(UserLocation.timestamp.desc())\
        .first()
    
    if not latest_location:
        raise HTTPException(status_code=404, detail="No location recorded. Tracking must be active.")

    # Fetch emergency contacts
    contacts = db.query(EmergencyContact)\
        .filter(EmergencyContact.user_id == current_user.id)\
        .all()
    
    if not contacts:
        raise HTTPException(status_code=404, detail="No contacts found. Please add emergency contacts.")

    # Format Google Maps Search URL (lat,long)
    maps_url = f"https://www.google.com/maps/search/?api=1&query={latest_location.latitude},{latest_location.longitude}"
    
    alert_msg = f"EMERGENCY ALERT: {current_user.username} needs help! Last seen here: {maps_url}"
    
    return {
        "message": alert_msg,
        "last_location": latest_location,
        "contacts_notified": contacts
    }