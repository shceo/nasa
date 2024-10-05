from fastapi import FastAPI
from app.api import events

app = FastAPI()

# Подключаем маршруты
app.include_router(events.router)
