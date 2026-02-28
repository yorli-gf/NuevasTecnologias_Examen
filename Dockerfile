# Usar una imagen base ligera de Python
FROM python:3.11-slim

# Evitar que Python genere archivos .pyc y habilitar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends 
    gcc 
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias de la app
COPY app/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la app
COPY app/ /app/

# Exponer el puerto 8000
EXPOSE 8000

# Comando para ejecutar la app con Gunicorn
CMD ["gunicorn", "parcial.wsgi:application", "--bind", "0.0.0.0:8000"]
