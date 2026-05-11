from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship

# 1. Database URL
# This tells SQLAlchemy to create a local file called 'waitsafe.db' in your backend folder.
DATABASE_URL = "sqlite:///./waitsafe.db"

# 2. Setup Engine and Session
# 'check_same_thread': False is required specifically for SQLite + FastAPI.
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# 3. User Table
class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    password = Column(String)  # We will hash this in the next phase!
    
    # This allows us to access a user's contacts using user.contacts
    contacts = relationship("EmergencyContact", back_populates="owner")

# 4. Emergency Contacts Table
class EmergencyContact(Base):
    __tablename__ = "contacts"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    phone = Column(String)
    
    # Foreign Key links this contact to a specific user id
    user_id = Column(Integer, ForeignKey("users.id"))
    
    # This allows us to see who the contact belongs to using contact.owner
    owner = relationship("User", back_populates="contacts")

# 5. Helper function to create tables
# When you call this, it checks the .db file and creates these tables if they don't exist.
def init_db():
    Base.metadata.create_all(bind=engine)