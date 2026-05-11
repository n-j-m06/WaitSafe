from fastapi import FastAPI
# Using absolute imports relative to the backend root
from app.models.database import init_db
from app.api import auth, contacts 

app = FastAPI(title="WaitSafe API")

@app.on_event("startup")
def on_startup():
    init_db()
    print("WaitSafe Database Initialized!")

app.include_router(auth.router)
app.include_router(contacts.router)

@app.get("/")
def read_root():
    return {"status": "WaitSafe Backend is running"}