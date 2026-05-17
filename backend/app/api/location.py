import math
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.models.database import (
    SessionLocal,
    UserLocation,
    SafeZone,
    EmergencyContact,
)
from app.models.schemas import (
    LocationCreate,
    LocationResponse,
    SafeZoneCreate,
    SafeZoneResponse,
)
from app.api.auth import get_current_user
from app.services.sms_service import send_sms

router = APIRouter(prefix="/location", tags=["Location & Geofencing"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def calculate_distance(
    lat1: float,
    lon1: float,
    lat2: float,
    lon2: float,
) -> float:
    R = 6371000  # Earth radius in meters

    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)

    a = (
        math.sin(dphi / 2) ** 2
        + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c


@router.post("/", response_model=LocationResponse)
def update_location(
    location: LocationCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    # Save latest user location
    new_loc = UserLocation(
        latitude=location.latitude,
        longitude=location.longitude,
        user_id=current_user.id,
    )

    db.add(new_loc)
    db.commit()
    db.refresh(new_loc)

    # Fetch all emergency contacts for this user
    emergency_contacts = (
        db.query(EmergencyContact)
        .filter(EmergencyContact.user_id == current_user.id)
        .all()
    )

    # Check Safe Zones
    safe_zones = (
        db.query(SafeZone)
        .filter(SafeZone.user_id == current_user.id)
        .all()
    )

    for zone in safe_zones:
        dist = calculate_distance(
            location.latitude,
            location.longitude,
            zone.latitude,
            zone.longitude,
        )

        # User has exited safe zone
        if dist > zone.radius_meters:
            alert_message = (
                f"EMERGENCY ALERT! {current_user.username} has exited safe zone "
                f"'{zone.name}' by {round(dist - zone.radius_meters)} meters. "
                f"Current location: https://maps.google.com/?q="
                f"{location.latitude},{location.longitude}"
            )

            # Send alert to ALL saved emergency contacts
            for contact in emergency_contacts:
                send_sms(
                    contact.phone,
                    alert_message,
                )

            print(alert_message)

    return new_loc


@router.post("/panic")
def panic_alert(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    # Fetch all emergency contacts
    emergency_contacts = (
        db.query(EmergencyContact)
        .filter(EmergencyContact.user_id == current_user.id)
        .all()
    )

    # Fetch latest known user location
    latest_location = (
        db.query(UserLocation)
        .filter(UserLocation.user_id == current_user.id)
        .order_by(UserLocation.timestamp.desc())
        .first()
    )

    location_link = "Location unavailable"

    if latest_location:
        location_link = (
            f"https://maps.google.com/?q="
            f"{latest_location.latitude},{latest_location.longitude}"
        )

    alert_message = (
        f"PANIC SOS ALERT! {current_user.username} triggered emergency assistance. "
        f"Current location: {location_link}"
    )

    # Send to ALL emergency contacts
    for contact in emergency_contacts:
        send_sms(
            contact.phone,
            alert_message,
        )

    print(alert_message)

    return {"message": "Panic SOS sent successfully"}


@router.post("/safe-zone", response_model=SafeZoneResponse)
def create_safe_zone(
    zone: SafeZoneCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    new_zone = SafeZone(
        **zone.model_dump(),
        user_id=current_user.id,
    )

    db.add(new_zone)
    db.commit()
    db.refresh(new_zone)

    return new_zone


@router.get("/safe-zones", response_model=List[SafeZoneResponse])
def get_safe_zones(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return (
        db.query(SafeZone)
        .filter(SafeZone.user_id == current_user.id)
        .all()
    )


@router.delete("/safe-zone/{zone_id}")
def delete_safe_zone(
    zone_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    zone = (
        db.query(SafeZone)
        .filter(
            SafeZone.id == zone_id,
            SafeZone.user_id == current_user.id,
        )
        .first()
    )

    if not zone:
        raise HTTPException(
            status_code=404,
            detail="Safe zone not found",
        )

    db.delete(zone)
    db.commit()

    return {"message": "Safe zone deleted successfully"}