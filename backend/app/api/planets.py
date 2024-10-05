from fastapi import APIRouter
from app.models.planet import Planet

router = APIRouter()

# Модель данных для планет
PLANETS = [
    Planet(name="Mercury", temperature="-173 to 427°C", radius="2,439.7 km", gravity="3.7 m/s²"),
    Planet(name="Venus", temperature="462°C", radius="6,051.8 km", gravity="8.87 m/s²"),
    Planet(name="Earth", temperature="-88 to 58°C", radius="6,371 km", gravity="9.81 m/s²"),
    Planet(name="Mars", temperature="-63°C", radius="3,389.5 km", gravity="3.71 m/s²"),
    Planet(name="Jupiter", temperature="-108°C", radius="69,911 km", gravity="24.79 m/s²"),
    Planet(name="Saturn", temperature="-139°C", radius="58,232 km", gravity="10.44 m/s²"),
    Planet(name="Uranus", temperature="-195°C", radius="25,362 km", gravity="8.69 m/s²"),
    Planet(name="Neptune", temperature="-201°C", radius="24,622 km", gravity="11.15 m/s²")
]

@router.get("/planets", response_model=list[Planet])
def get_planets():
    """Возвращает список планет солнечной системы с основной информацией."""
    return PLANETS
