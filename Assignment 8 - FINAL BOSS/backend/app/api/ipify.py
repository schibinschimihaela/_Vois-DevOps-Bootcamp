import requests


def get_ip():
    return requests.get("https://api.ipify.org?format=json", timeout=5).json()["ip"]
