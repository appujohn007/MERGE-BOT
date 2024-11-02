FROM python:3.11

# Set the working directory
WORKDIR /usr/src/mergebot

# Copy all project files
COPY . /usr/src/mergebot

# Set permissions for the project directory
RUN chown -R mergebotuser:mergebotgroup /usr/src/mergebot && \
    chmod -R 775 /usr/src/mergebot

# Create an empty, writable log file
RUN touch /usr/src/mergebot/mergebotlog.txt && \
    chmod 666 /usr/src/mergebot/mergebotlog.txt

# Update pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

RUN pip install -r needs.txt 

RUN pip install python-dotenv 

# Create and activate the virtual environment, and install dependencies
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r needs.txt

# Install necessary system packages
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git wget curl pv jq ffmpeg neofetch mediainfo && \
    apt-get clean

# Make start.sh executable before switching users
RUN chmod +x start.sh

# Create a non-root user with UID and GID within the required range
RUN addgroup --gid 10001 mergebotgroup && \
    adduser --disabled-password --gecos "" --uid 10001 --gid 10001 mergebotuser

# Change ownership of mergebotlog.txt to the non-root user
RUN chown mergebotuser:mergebotgroup /usr/src/mergebot/mergebotlog.txt

# Switch to the non-root user
USER mergebotuser

# Expose the port
EXPOSE 8080

# Start the application
CMD ["python", "bot.py"]
