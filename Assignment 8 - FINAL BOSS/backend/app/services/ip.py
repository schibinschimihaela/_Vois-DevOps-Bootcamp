from app.api.ipify import get_ip
from app.api.geolocation import locate_ip
from app.services.logs import save_log

def scan_ip(ip: str | None = None):
    target_ip = ip or get_ip()
    geo = locate_ip(target_ip)

    save_log(
        ip=target_ip,
        country=geo.get("country"),
        city=geo.get("city"),
        isp=geo.get("isp"),
    )

    return {
        "ip": target_ip,
        "country": geo.get("country"),
        "city": geo.get("city"),
        "isp": geo.get("isp"),
    }
