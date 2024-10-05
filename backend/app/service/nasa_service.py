import httpx
import os

NASA_API_KEY = os.getenv("8hZXdZ7rKPkWyjnsT33McdkB9WaeAebqD0OoHfR1")  # Получаем ключ NASA API из переменных окружения

async def get_upcoming_events():
    """Функция для получения данных о предстоящих космических событиях с NASA API."""
    url = f"https://api.nasa.gov/planetary/apod?api_key={NASA_API_KEY}"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            return {"error": "Не удалось получить данные о событиях"}
