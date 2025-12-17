# IP Spectre – Shadow Network Scanner

**IP Spectre** is a cyberpunk-inspired Command Line Interface (CLI) tool that simulates a shadow network monitoring console.

The application detects the current public IP address, enriches it with geolocation data using external APIs, and stores the collected traces in a **real AWS DynamoDB table**.  
All actions are orchestrated through a **Makefile**, following DevOps-style automation practices.

This project was developed for **Module 3 – Scripting with Python and Bash**.

---

## Key Features

- Interactive hacker-style CLI with ASCII banner, colors, and loading animations  
- Public IP detection using an external API  
- IP geolocation (country, city, ISP)  
- Persistent storage using **AWS DynamoDB**  
- Multiple CLI actions through a menu-driven interface  
- Full automation via Makefile commands  
- Runs locally on any machine with Python and AWS credentials  

---

## Technologies Used

- **Python 3**
- **AWS DynamoDB** (via boto3)
- **AWS STS** (credential verification)
- **Makefile**
- **External APIs**
  - ipify.org – public IP detection
  - ip-api.com – IP geolocation
- **Python libraries**
  - rich
  - pyfiglet
  - requests
  - boto3
  - python-dotenv

---

## Installation & Setup

### 1. Create and activate a virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2. Install dependencies
```bash
make install
```

### 3. Configure AWS
Ensure AWS credentials are configured locally:
```bash
aws configure
```

Create a `.env` file in the project root:
```env
AWS_REGION=eu-west-1
```

### 4. Create the DynamoDB table
```bash
make create-db
```

---

## Running the Application

Start the interactive CLI:
```bash
make run
```

You will be presented with a menu-driven terminal interface.

---

## CLI Menu Actions

The CLI provides **6 interactive actions**, fulfilling the assignment requirements:

1. **Scan current IP**  
   Detects the public IP, fetches geolocation data, and stores the trace in DynamoDB.

2. **View logs (DynamoDB)**  
   Displays the most recent stored IP traces in a formatted table.

3. **Purge logs (DynamoDB)**  
   Deletes all stored records from the DynamoDB table (confirmation required).

4. **AWS status**  
   Displays the configured AWS region and verifies credentials using AWS STS.

5. **Help**  
   Shows a short description of all available commands.

6. **Exit**  
   Safely exits the CLI interface.

---

## Makefile Commands

| Command | Description |
|-------|------------|
| `install` | Install all required Python dependencies |
| `run` | Launch the interactive CLI |
| `clean` | Remove temporary files |
| `create-db` | Create the DynamoDB table |
| `purge-db` | Delete all records from the table |
| `scan-ip` | Run a one-shot IP scan without entering the menu |

---

## AWS Integration

- **Service:** DynamoDB  
- **Billing mode:** PAY_PER_REQUEST  
- **Purpose:** Persistent storage of IP trace logs  

This integration is **real and verifiable**, not simulated.

---

## Project Objectives

This project demonstrates:
- Python scripting for real-world automation  
- Bash/Makefile-based orchestration  
- Cloud service integration  
- External API consumption  
- Design of a polished and user-friendly CLI tool  

---

**Welcome to the shadows. The network is watching.**
