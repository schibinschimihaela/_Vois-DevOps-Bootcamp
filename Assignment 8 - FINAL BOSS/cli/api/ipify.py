import requests

def get_ip():
    return requests.get("https://api.ipify.org?format=json").json()["ip"]
