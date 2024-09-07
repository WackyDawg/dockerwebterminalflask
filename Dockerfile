# Use the official Kali Linux image as a base
FROM FROM parrotsec/security:latest

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the entire current directory into the container at /app
COPY . /app

# Install pyxtermjs (or other Python dependencies)
RUN pip3 install -r requirements.txt --break-system-packages

# Run the main Python script when the container starts
CMD ["python3", "main.py"]
