FROM python:3.11-slim

RUN useradd -m appuser
WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY cli/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY cli/ .

USER appuser

CMD ["python", "cli.py"]
