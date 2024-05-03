# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Disable buffering to ensure logs are printed immediately
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /code

# Copy only requirements to the container
COPY requirements.txt /code/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire codebase into the container
COPY . /code/

# Make port 8000 available
EXPOSE 8000

# Run the Django application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
