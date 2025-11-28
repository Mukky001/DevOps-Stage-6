# Use Python 3.6 (Buster) to support legacy thriftpy 0.3.9
FROM python:3.6-slim-buster

WORKDIR /app

# FIX: Debian Buster is EOL. 
# 1. Overwrite sources.list to point to the archive.
# 2. Use -o Acquire::Check-Valid-Until=false because archive metadata is expired.
# 3. Install gcc and update pip.
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y --no-install-recommends gcc libc6-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip

COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["python", "main.py"]
