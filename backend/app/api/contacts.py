# Complete backend/app/api/contacts.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from jose import JWTError, jwt
from fastapi.security import OAuth2PasswordBearer
from app.models.database import SessionLocal, EmergencyContact, User
from app.models.schemas import ContactCreate, ContactResponse
from app.core.security import SECRET_KEY, ALGORITHM

router = APIRouter(prefix="/contacts", tags=["Emergency Contacts"])
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Helper to get current user from the token
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise credentials_exception
    return user

@router.post("/", response_model=ContactResponse)
def add_contact(contact: ContactCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Now user_id is automatically pulled from the token!
    new_contact = EmergencyContact(
        name=contact.name, 
        phone=contact.phone, 
        user_id=current_user.id
    )
    db.add(new_contact)
    db.commit()
    db.refresh(new_contact)
    return new_contact

@router.get("/", response_model=List[ContactResponse])
def get_contacts(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Returns ONLY the contacts for the logged-in user
    return db.query(EmergencyContact).filter(EmergencyContact.user_id == current_user.id).all()