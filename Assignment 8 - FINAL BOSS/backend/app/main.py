from fastapi import FastAPI, Query
from app.services.logs import view_logs, purge_logs
from app.services.ip import scan_ip
from app.services.aws import aws_status

app = FastAPI(title="IP Spectre API")

@app.get("/scan")
def scan(ip: str | None = Query(default=None)):
    return scan_ip(ip)

@app.get("/logs")
def logs():
    return view_logs()

@app.delete("/logs")
def delete_logs():
    return {"deleted": purge_logs()}

@app.get("/aws/status")
def status():
    return aws_status()
