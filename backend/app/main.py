from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, contacts, location, alerts
from app.models.database import init_db

app = FastAPI(title="WaitSafe API - Personal Safety Engine")

# Initialize database tables
init_db()

# --- CORS Configuration ---
# This is essential for when we connect your React/Frontend later
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Allows all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Route Registration ---
app.include_router(auth.router)
app.include_router(contacts.router)
app.include_router(location.router)
app.include_router(alerts.router)

@app.get("/")
def read_root():
    return {
        "status": "online",
        "project": "WaitSafe",
        "message": "Backend Security Engine is active and monitoring."
    }