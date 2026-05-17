from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api import auth, contacts, location, alerts, timers, panic
from app.models.database import init_db

app = FastAPI(
    title="WaitSafe API",
    description="Backend for AI-Powered Women's Safety Analytics & Emergency Response",
    version="1.0.0"
)

# Initialize database
init_db()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Global Exception Handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "message": "An unexpected error occurred on the server.",
            "details": str(exc),
        },
    )


# Include all feature routers
app.include_router(auth.router)
app.include_router(contacts.router)
app.include_router(location.router)
app.include_router(alerts.router)
app.include_router(timers.router)
app.include_router(panic.router)


# Root
@app.get("/")
def read_root():
    return {
        "status": "Online",
        "project": "WaitSafe",
        "developer": "Niranjan",
        "location": "Chennai",
    }