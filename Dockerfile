# Build stage
FROM python:3.9-slim AS builder

RUN apt-get update && apt-get -y install procps net-tools curl lsof less && apt-get clean

WORKDIR /app

COPY app.py requirements.txt /app/

# Production stage
FROM python:3.9-slim

WORKDIR /app

COPY --from=builder /app /app
# Here we install gunicorn in the final Docker image
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD gunicorn -w 4 -b 0.0.0.0:8080 app:app

