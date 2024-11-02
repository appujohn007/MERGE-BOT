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

# Create a non-root user and switch to it
RUN addgroup --gid 1001 mergebotgroup && \
    adduser --disabled-password --gecos "" --uid 1001 --gid 1001 mergebotuser

# Switch to the non-root user
USER mergebotuser

# Expose the port
EXPOSE 8080

# Make start.sh executable
RUN chmod +x start.sh

# Start the application
CMD ["python", "bot.py"]
