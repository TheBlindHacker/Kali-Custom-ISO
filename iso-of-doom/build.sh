#!/bin/bash
set -e

# Check for root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Install dependencies if missing
echo "[*] checking/installing live-build..."
apt-get update
apt-get install -y live-build cdebootstrap

# Clean previous builds
lb clean

# Run the live-build config
echo "[*] Configuring build..."
lb config

# Build the ISO
echo "[*] Building Kali ISO of Doom II..."
lb build
