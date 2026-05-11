from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, contacts, location, alerts, timers
from app.models.database import init_db

app = FastAPI(title="WaitSafe API")

# Initialize DB
init_db()

# Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(auth.router)
app.include_router(contacts.router)
app.include_router(location.router)
app.include_router(alerts.router)
app.include_router(timers.router)

@app.get("/")
def read_root():
    return {"message": "WaitSafe Backend is active"}