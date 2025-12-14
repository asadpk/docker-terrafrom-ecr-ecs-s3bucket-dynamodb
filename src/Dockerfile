#use Python as the base image
FROM python:3.8-slim-buster

# Set the working directory
WORKDIR /app

# Copy requirements file and install dependencies
# `--no-cache-dir` prevents pip from saving temporary files, keeping the environment lightweight.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask application files
COPY . /app

# Start Gunicorn server
# Start Flask application using Gunicorn with 1 worker, binding to all network interfaces on port 8000
CMD ["gunicorn", "--workers", "1", "--bind", "0.0.0.0:8000", "humangov:app"]
