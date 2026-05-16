from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.models.database import SessionLocal, EmergencyContact
from app.api.auth import get_current_user

router = APIRouter(prefix="/alerts", tags=["Emergency Alerts"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/panic")
def trigger_panic(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    # Get all emergency contacts for logged-in user
    contacts = (
        db.query(EmergencyContact)
        .filter(EmergencyContact.user_id == current_user.id)
        .all()
    )

    if not contacts:
        raise HTTPException(
            status_code=400,
            detail="No emergency contacts found. Please add contacts first.",
        )

    # Simulated alert
    return {
        "message": "Panic alert triggered successfully",
        "user_id": current_user.id,
        "contacts_alerted": len(contacts),
        "status": "ACTIVE",
    }


@router.post("/trigger-timer-alert")
def trigger_timer_alert(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    contacts = (
        db.query(EmergencyContact)
        .filter(EmergencyContact.user_id == current_user.id)
        .all()
    )

    if not contacts:
        raise HTTPException(
            status_code=400,
            detail="No emergency contacts found for timer alert.",
        )

    return {
        "message": "Timer expired. Emergency alert triggered.",
        "user_id": current_user.id,
        "contacts_alerted": len(contacts),
        "status": "TIMER_ALERT",
    }