# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Set environment variable to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    xfce4-terminal \
    xvfb \
    nautilus \
    nano \
    git \
    curl \
    wget \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    dpkg --install chrome-remote-desktop_current_amd64.deb && \
    apt-get install --assume-yes --fix-broken && \
    apt-get install --assume-yes xfce4 desktop-base xscreensaver

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --install google-chrome-stable_current_amd64.deb && \
    apt-get install --assume-yes --fix-broken

# Install Visual Studio Code
RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb && \
    dpkg --install code.deb && \
    apt-get install -f

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs

# Set up Chrome Remote Desktop session
RUN echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session

# Set environment variable for Chrome Remote Desktop
ENV DISPLAY=:1

# Add a script to start Chrome Remote Desktop
RUN echo '#!/bin/bash\n\
/opt/google/chrome-remote-desktop/start-host --code="4/0AQlEd8w0-H-jeNa4pW_8KuDkxV8xRjZNsLXodT_AcIuX-_daYQg6JK48-1JVbV2QGAxI4Q" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)' > /start-remote-desktop.sh && \
    chmod +x /start-remote-desktop.sh

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the entire current directory into the container at /app
COPY . /app

# Change ownership of the /app directory to the new user
RUN chown -R myuser:myuser /app

# Switch to the non-root user
USER myuser

# Install Python dependencies
RUN pip3 install -r requirements.txt --break-system-packages

# Run the script to start Chrome Remote Desktop and the main Python script
CMD ["/bin/bash", "-c", "/start-remote-desktop.sh && python3 main.py"]
