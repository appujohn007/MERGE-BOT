FROM python:3.11

# Set the working directory
WORKDIR /usr/src/mergebot

# Copy all project files
COPY . /usr/src/mergebot

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

# Switch to the non-root user
USER 10001

# Expose the port
EXPOSE 8080

# Start the application
CMD ["python", "bot.py"]
