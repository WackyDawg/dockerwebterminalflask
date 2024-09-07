# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and set the password
RUN useradd -m -s /bin/bash myuser \
    && echo "myuser:123456" | chpasswd \
    && adduser myuser sudo \
    && echo "myuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the working directory in the container
WORKDIR /app

# Copy the entire current directory into the container at /app
COPY . /app

# Change ownership of the /app directory to the new user
RUN chown -R myuser:myuser /app

# Switch to the non-root user
USER myuser

# Install Python dependencies as the non-root user
RUN pip3 install -r requirements.txt --break-system-packages

# Run the main Python script when the container starts
CMD ["python3", "main.py"]
