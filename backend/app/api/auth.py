from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.database import SessionLocal, User
from app.models.schemas import UserCreate, UserResponse

router = APIRouter(prefix="/auth", tags=["Authentication"])

# Helper function to get a database connection
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/signup", response_model=UserResponse)
def signup(user_data: UserCreate, db: Session = Depends(get_db)):
    # 1. Check if the username already exists
    existing_user = db.query(User).filter(User.username == user_data.username).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    
    # 2. Create the new User (We'll add hashing later, keeping it simple for now)
    new_user = User(username=user_data.username, password=user_data.password)
    
    # 3. Save to the database
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return new_user