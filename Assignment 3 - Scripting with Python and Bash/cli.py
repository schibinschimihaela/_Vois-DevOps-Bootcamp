import os
import sys
import time
from datetime import datetime

import boto3
import pyfiglet
from rich.console import Console
from rich.prompt import Prompt
from rich.table import Table
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn

from api.ipify import get_ip
from api.geolocation import locate_ip

console = Console()

TABLE_NAME = "ip_spectre_logs"


def clear_screen() -> None:
    os.system("clear" if os.name != "nt" else "cls")


def banner() -> None:
    ascii_banner = pyfiglet.figlet_format("IP SPECTRE")
    console.print(ascii_banner, style="bold green")


def get_region() -> str:
    region = os.getenv("AWS_REGION")
    if not region:
        region = boto3.session.Session().region_name
    return region or ""


def get_table():
    region = get_region()
    if not region:
        raise RuntimeError("AWS_REGION is not set. Create a .env with AWS_REGION=eu-west-1 (or export it).")

    dynamodb = boto3.resource("dynamodb", region_name=region)
    return dynamodb.Table(TABLE_NAME)


def loading(msg: str, seconds: float = 0.6) -> None:
    with Progress(
        SpinnerColumn(),
        TextColumn("[bold cyan]{task.description}"),
        transient=True,
        console=console,
    ) as progress:
        task = progress.add_task(msg, total=None)
        time.sleep(seconds)
        progress.update(task, completed=1)


def action_scan_ip() -> None:
    loading("Intercepting node identity...")
    ip = get_ip()

    loading("Cross-referencing geolocation...")
    geo = locate_ip(ip)

    table = get_table()
    table.put_item(
        Item={
            "ip": ip,
            "country": geo.get("country") or "Unknown",
            "city": geo.get("city") or "Unknown",
            "isp": geo.get("isp") or "Unknown",
            "timestamp": datetime.utcnow().isoformat(timespec="seconds") + "Z",
        }
    )

    console.print(Panel.fit(
        f"[green]IP detected:[/green] {ip}\n"
        f"[cyan]Location:[/cyan] {geo.get('city')}, {geo.get('country')}\n"
        f"[magenta]ISP:[/magenta] {geo.get('isp')}",
        title="Trace Captured",
        border_style="green"
    ))


def action_view_logs() -> None:
    loading("Decrypting shadow logs from DynamoDB...")
    table_obj = get_table()
    resp = table_obj.scan()

    items = resp.get("Items", [])
    if not items:
        console.print("[yellow]No logs found.[/yellow]")
        return

    # sort newest first if timestamp exists
    items.sort(key=lambda x: x.get("timestamp", ""), reverse=True)

    t = Table(title="IP Spectre Logs", show_lines=False)
    t.add_column("Timestamp", style="dim", overflow="fold")
    t.add_column("IP", style="bold")
    t.add_column("City")
    t.add_column("Country")
    t.add_column("ISP", overflow="fold")

    for it in items[:20]:
        t.add_row(
            it.get("timestamp", "-"),
            it.get("ip", "-"),
            it.get("city", "-"),
            it.get("country", "-"),
            it.get("isp", "-"),
        )

    console.print(t)
    if len(items) > 20:
        console.print(f"[dim]Showing 20 of {len(items)} items.[/dim]")


def action_purge_logs() -> None:
    console.print("[bold red] !!! This will DELETE ALL records from DynamoDB.[/bold red]")
    confirm = Prompt.ask("Type [bold]PURGE[/bold] to confirm", default="no")
    if confirm.strip().upper() != "PURGE":
        console.print("[yellow]Cancelled.[/yellow]")
        return

    loading("Wiping shadow records...")
    table_obj = get_table()
    resp = table_obj.scan()
    items = resp.get("Items", [])

    with table_obj.batch_writer() as batch:
        for it in items:
            if "ip" in it:
                batch.delete_item(Key={"ip": it["ip"]})

    console.print(f"[green] Purged {len(items)} items from {TABLE_NAME}.[/green]")


def action_aws_status() -> None:
    region = get_region()
    console.print(Panel.fit(
        f"[cyan]AWS_REGION:[/cyan] {region or 'NOT SET'}\n"
        f"[cyan]Table:[/cyan] {TABLE_NAME}",
        title="Local AWS Status",
        border_style="cyan"
    ))

    try:
        loading("Verifying AWS identity (STS)...")
        sts = boto3.client("sts", region_name=region if region else None)
        ident = sts.get_caller_identity()
        console.print(
            f"[green] Auth OK [/green]\n"
            f"Account: [bold]{ident.get('Account')}[/bold]\n"
            f"ARN: {ident.get('Arn')}"
        )
    except Exception as e:
        console.print(f"[red] AWS STS check failed:[/red] {e}")


def action_help() -> None:
    console.print(Panel(
        "[bold]Commands[/bold]\n"
        "1) Scan current IP → calls ipify + ip-api and stores result in DynamoDB\n"
        "2) View logs → scans DynamoDB and shows latest traces\n"
        "3) Purge logs → deletes all records from DynamoDB\n"
        "4) AWS status → shows region + verifies AWS credentials via STS\n"
        "5) Exit\n",
        title="Operator Manual",
        border_style="magenta"
    ))


def menu() -> None:
    while True:
        clear_screen()
        banner()
        console.print("[dim]NeoCity // Sector 7 // Shadow Node Console[/dim]\n")

        console.print("[1] Scan current IP")
        console.print("[2] View logs (DynamoDB)")
        console.print("[3] Purge logs (DynamoDB)")
        console.print("[4] AWS status")
        console.print("[5] Help")
        console.print("[6] Exit")

        choice = Prompt.ask("\nSelect action", default="6").strip()

        try:
            if choice == "1":
                action_scan_ip()
            elif choice == "2":
                action_view_logs()
            elif choice == "3":
                action_purge_logs()
            elif choice == "4":
                action_aws_status()
            elif choice == "5":
                action_help()
            elif choice == "6":
                console.print("[dim]Disconnecting...[/dim]")
                break
            else:
                console.print("[yellow]Unknown option.[/yellow]")
        except Exception as e:
            console.print(f"[red]Error:[/red] {e}")

        input("\nPress Enter to continue...")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--scan":
        action_scan_ip()
    else:
        menu()
