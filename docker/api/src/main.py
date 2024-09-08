from fastapi import FastAPI
from src.utils import get_server_info

app = FastAPI()


@app.get("/")
def read_root():
    info = get_server_info()
    print(info)
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}