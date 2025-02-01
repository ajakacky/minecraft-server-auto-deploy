from fastapi import FastAPI
from src.services import get_server_info, get_all_ec2_instance_ids

app = FastAPI()


@app.get("/servers")
def read_root():
    return get_all_ec2_instance_ids()


@app.get("/servers/{instance_id}/status")
def read_item(instance_id: str):
    return get_server_info(instance_id)
