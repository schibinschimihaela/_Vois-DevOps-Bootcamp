import requests

def locate_ip(ip):
    data = requests.get(f"http://ip-api.com/json/{ip}").json()
    return {
        "country": data.get("country"),
        "city": data.get("city"),
        "isp": data.get("isp")
    }
