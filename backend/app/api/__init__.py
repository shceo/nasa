# app/api/__init__.py
from .planets import router as planets_router
from .events import router as events_router

# Теперь можно импортировать роуты сразу:
# from app.api import planets_router, events_router
