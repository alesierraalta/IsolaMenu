# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container to /code
WORKDIR /code

# Add the current directory contents into the container at /code
ADD . /code

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Define environment variable, replace 'World' with a value suitable for your environment
ENV NAME World

# Run manage.py to start the Django application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
