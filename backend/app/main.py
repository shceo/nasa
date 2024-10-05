from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

# Добавьте ваши маршруты из api/events.py, если необходимо
