from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
import datetime

SQLALCHEMY_DATABASE_URL = "sqlite:///./waitsafe.db"

engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)

    # Relationships
    contacts = relationship("EmergencyContact", back_populates="owner")
    locations = relationship("UserLocation", back_populates="owner")
    safe_zones = relationship("SafeZone", back_populates="owner")

class EmergencyContact(Base):
    __tablename__ = "emergency_contacts"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    phone = Column(String)
    user_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="contacts")

class UserLocation(Base):
    __tablename__ = "user_locations"
    id = Column(Integer, primary_key=True, index=True)
    latitude = Column(Float)
    longitude = Column(Float)
    timestamp = Column(DateTime, default=datetime.datetime.utcnow)
    user_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="locations")

class SafeZone(Base):
    __tablename__ = "safe_zones"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)  # e.g., "Home", "College"
    latitude = Column(Float)
    longitude = Column(Float)
    radius_meters = Column(Float, default=500.0)
    user_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="safe_zones")

def init_db():
    Base.metadata.create_all(bind=engine)