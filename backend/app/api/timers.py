from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from app.models.database import SessionLocal, CheckInTimer
from app.models.schemas import TimerCreate, TimerResponse
from app.api.auth import get_current_user

router = APIRouter(prefix="/timers", tags=["Safety Timers"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/start", response_model=TimerResponse)
def start_timer(timer_in: TimerCreate, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    # Deactivate any existing active timers for this user first
    db.query(CheckInTimer).filter(
        CheckInTimer.user_id == current_user.id, 
        CheckInTimer.is_active == True
    ).update({"is_active": False})
    
    # Calculate expiry time
    expiry = datetime.utcnow() + timedelta(minutes=timer_in.duration_minutes)
    
    new_timer = CheckInTimer(expires_at=expiry, user_id=current_user.id)
    db.add(new_timer)
    db.commit()
    db.refresh(new_timer)
    return new_timer

@router.post("/check-in")
def check_in(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    timer = db.query(CheckInTimer).filter(
        CheckInTimer.user_id == current_user.id, 
        CheckInTimer.is_active == True
    ).first()
    
    if not timer:
        raise HTTPException(status_code=404, detail="No active timer found.")
    
    # User checked in! Deactivate the timer.
    timer.is_active = False
    db.commit()
    return {"message": "Safe Check-in successful. Timer deactivated."}

@router.get("/status")
def get_status(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    timer = db.query(CheckInTimer).filter(
        CheckInTimer.user_id == current_user.id, 
        CheckInTimer.is_active == True
    ).first()
    
    if not timer:
        return {"status": "inactive"}
    
    is_overdue = datetime.utcnow() > timer.expires_at
    return {
        "status": "active",
        "expires_at": timer.expires_at,
        "is_overdue": is_overdue,
        "current_time": datetime.utcnow()
    }