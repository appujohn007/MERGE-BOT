FROM python:3.11

# Set the working directory
WORKDIR /usr/src/mergebot

# Create a non-root user with UID and GID in the required range
RUN addgroup --gid 10001 mergebotgroup && \
    adduser --disabled-password --gecos "" --uid 10001 --gid 10006 mergebotuser

# Copy all project files (done after user creation)
COPY . /usr/src/mergebot

# Set permissions for the project directory
RUN chown -R mergebotuser:mergebotgroup /usr/src/mergebot && \
    chmod -R 775 /usr/src/mergebot

# Update pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Create an empty, writable log file
RUN touch /usr/src/mergebot/mergebotlog.txt && \
    chown mergebotuser:mergebotgroup /usr/src/mergebot/mergebotlog.txt && \
    chmod 666 /usr/src/mergebot/mergebotlog.txt

# Switch to the non-root user
USER mergebotuser

# Install necessary system packages
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git wget curl pv jq ffmpeg neofetch mediainfo && \
    apt-get clean

# Create and activate the virtual environment, and install dependencies
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r needs.txt

# Make start.sh executable
RUN chmod +x start.sh

# Expose the port
EXPOSE 8080

# Start the application
CMD ["python", "bot.py"]
