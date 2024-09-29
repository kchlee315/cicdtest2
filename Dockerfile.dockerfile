# Use an official Python runtime as a parent image
FROM python:3.9-slim
# Set the working directory in the container
WORKDIR /app
# Copy the current directory contents into the container at /app
# Install any needed packages specified in requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Make port 5000 available to the world outside this container
# Define environment variable
COPY . .
# Run app.py when the container launches
CMD ["python", "run.py"]