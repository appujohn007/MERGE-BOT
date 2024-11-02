FROM python:3.11

# Set the working directory
WORKDIR /usr/src/mergebot

# Copy all project files
COPY . /usr/src/mergebot

# Update pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Create and activate the virtual environment, and install dependencies
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r needs.txt

# Install necessary system packages
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y git wget curl pv jq ffmpeg neofetch mediainfo && \
    apt-get clean

# Expose the port
EXPOSE 8080

# Make start.sh executable
RUN chmod +x start.sh

# Start the application
CMD ["bash", "start.sh"]
