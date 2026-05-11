from fastapi import FastAPI
from app.api import auth, contacts, location
from app.models.database import init_db

app = FastAPI(title="WaitSafe API")

# Create tables
init_db()

app.include_router(auth.router)
app.include_router(contacts.router)
app.include_router(location.router)

@app.get("/")
def read_root():
    return {"message": "WaitSafe Backend is active"}