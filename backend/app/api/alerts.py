from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.database import SessionLocal, User, EmergencyContact, UserLocation, CheckInTimer
from app.models.schemas import PanicAlertResponse
from app.api.auth import get_current_user
import datetime

router = APIRouter(prefix="/alerts", tags=["Emergency Alerts"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/panic", response_model=PanicAlertResponse)
def trigger_panic(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    # 1. Fetch Emergency Contacts
    contacts = db.query(EmergencyContact).filter(EmergencyContact.user_id == current_user.id).all()
    if not contacts:
        raise HTTPException(status_code=400, detail="No emergency contacts found. Please add contacts first.")

    # 2. Get Last Known Location
    last_loc = db.query(UserLocation).filter(UserLocation.user_id == current_user.id).order_by(UserLocation.timestamp.desc()).first()
    
    location_link = "Location Unknown"
    if last_loc:
        location_link = f"https://www.google.com/maps?q={last_loc.latitude},{last_loc.longitude}"

    # 3. Simulate SMS Sending
    alert_msg = f"EMERGENCY ALERT from {current_user.username.upper()}! I need help. My last location: {location_link}"
    
    print("\n" + "="*50)
    print("🚀 SMS GATEWAY SIMULATION")
    for contact in contacts:
        print(f"To: {contact.phone} ({contact.name}) | Msg: {alert_msg}")
    print("="*50 + "\n")

    return {
        "message": "Panic alert triggered and contacts notified via Simulation.",
        "last_location": last_loc,
        "contacts_notified": contacts
    }

@router.post("/trigger-timer-alert")
def trigger_timer_alert(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    # Check if user has an overdue timer
    timer = db.query(CheckInTimer).filter(
        CheckInTimer.user_id == current_user.id,
        CheckInTimer.is_active == True
    ).first()

    if not timer or datetime.datetime.utcnow() <= timer.expires_at:
        raise HTTPException(status_code=400, detail="No overdue active timer found.")

    # If overdue, trigger the same panic logic
    return trigger_panic(db, current_user)