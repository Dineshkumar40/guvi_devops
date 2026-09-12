#!/bin/bash

set -e

echo "========================================"
echo " Installing Grafana"
echo "========================================"

# Update package information
sudo apt-get update

# Install required packages
sudo apt-get install -y apt-transport-https software-properties-common wget gnupg

echo "========================================"
echo " Adding Grafana Repository"
echo "========================================"

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Download Grafana GPG key
sudo wget -q -O /etc/apt/keyrings/grafana.asc \
https://apt.grafana.com/gpg-full.key

# Add Grafana repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" \
| sudo tee /etc/apt/sources.list.d/grafana.list

echo "========================================"
echo " Installing Grafana"
echo "========================================"

# Update package information
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

echo "========================================"
echo " Starting Grafana"
echo "========================================"

# Reload systemd
sudo systemctl daemon-reload

# Enable Grafana to start automatically on boot
sudo systemctl enable grafana-server

# Start Grafana
sudo systemctl start grafana-server

echo "========================================"
echo " Grafana Status"
echo "========================================"

sudo systemctl status grafana-server --no-pager

echo "========================================"
echo " Grafana installation completed!"
echo "========================================"
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
echo "Grafana URL:"
echo "http://$PUBLIC_IP:3000"

echo ""
echo "Default Grafana Login:"
echo "Username: admin"
echo "Password: admin"

echo ""
echo "IMPORTANT:"
echo "You will be asked to change the password after first login."
echo "========================================"