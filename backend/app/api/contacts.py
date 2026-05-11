from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.models.database import SessionLocal, EmergencyContact
from app.models.schemas import ContactCreate, ContactResponse
from app.api.auth import get_current_user

router = APIRouter(prefix="/contacts", tags=["Emergency Contacts"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=ContactResponse)
def add_contact(
    contact: ContactCreate, 
    db: Session = Depends(get_db), 
    current_user = Depends(get_current_user) # This is the "lock"
):
    # Create the new contact and link it to the user who is logged in
    new_contact = EmergencyContact(
        name=contact.name,
        phone=contact.phone,
        user_id=current_user.id
    )
    db.add(new_contact)
    db.commit()
    db.refresh(new_contact)
    return new_contact

@router.get("/", response_model=list[ContactResponse])
def get_contacts(
    db: Session = Depends(get_db), 
    current_user = Depends(get_current_user)
):
    return db.query(EmergencyContact).filter(EmergencyContact.user_id == current_user.id).all()