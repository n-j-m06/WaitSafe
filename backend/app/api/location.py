import math
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.models.database import SessionLocal, UserLocation, SafeZone
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

            # Replace with your real emergency contact number
            send_sms(
                "9363705062",
                alert_message,
            )

            print(alert_message)

    return new_loc


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