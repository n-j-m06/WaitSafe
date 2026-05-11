from fastapi import FastAPI
from app.models.database import init_db
from app.api import auth # Import your auth file

app = FastAPI(title="WaitSafe API")

@app.on_event("startup")
def on_startup():
    init_db()

# This tells FastAPI to include the signup routes
app.include_router(auth.router)

@app.get("/")
def read_root():
    return {"status": "WaitSafe Backend is running"}