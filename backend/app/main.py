from fastapi import FastAPI
# Removed "backend." from the start of the imports
from app.models.database import init_db
from app.api import auth 

app = FastAPI(title="WaitSafe API")

@app.on_event("startup")
def on_startup():
    init_db()
    print("Database connected and tables created!")

# This tells FastAPI to include the signup routes
app.include_router(auth.router)

@app.get("/")
def read_root():
    return {"status": "WaitSafe Backend is running"}