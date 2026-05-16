from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from datetime import datetime

from app.models.database import SessionLocal
from app.api.auth import get_current_user

router = APIRouter(prefix="/panic", tags=["Panic Alert"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/trigger")
def trigger_panic(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return {
        "message": "Panic alert triggered successfully",
        "user_id": current_user.id,
        "timestamp": datetime.utcnow(),
        "status": "ACTIVE",
    }