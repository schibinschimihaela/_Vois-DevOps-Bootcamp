# Stage 1 – Builder

FROM python:3.11 AS builder

WORKDIR /build

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt

# Stage 2 – Runtime

FROM python:3.11-slim AS runtime

WORKDIR /app

COPY --from=builder /install /usr/local

COPY app.py .

CMD ["python", "app.py"]
