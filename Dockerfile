FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput || true

EXPOSE 5000

CMD ["sh", "-c", "python manage.py migrate --noinput && python manage.py createcachetable --verbosity 0 || true && gunicorn config.wsgi --bind 0.0.0.0:${PORT:-5000} --timeout 120"]
