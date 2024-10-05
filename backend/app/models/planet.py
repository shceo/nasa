from pydantic import BaseModel

class Planet(BaseModel):
    name: str
    temperature: str
    radius: str
    gravity: str
