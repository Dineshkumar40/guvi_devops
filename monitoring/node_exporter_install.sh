#!/bin/bash

set -e

echo "========================================"
echo " Installing Node Exporter"
echo "========================================"

# Create Node Exporter user
sudo useradd --no-create-home --shell /bin/false node_exporter 2>/dev/null || true

# Create temporary directory
sudo mkdir -p /tmp/node_exporter

# Go to temporary directory
cd /tmp/node_exporter

# Download Node Exporter
sudo wget -q https://github.com/prometheus/node_exporter/releases/download/v1.12.1/node_exporter-1.12.1.linux-amd64.tar.gz

# Extract Node Exporter
sudo tar -xvf node_exporter-1.12.1.linux-amd64.tar.gz

# Copy Node Exporter binary
sudo cp node_exporter-1.12.1.linux-amd64/node_exporter /usr/local/bin/

# Set ownership
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

echo "========================================"
echo " Creating Node Exporter service"
echo "========================================"

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple

ExecStart=/usr/local/bin/node_exporter

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "========================================"
echo " Starting Node Exporter"
echo "========================================"

# Reload systemd
sudo systemctl daemon-reload

# Enable and start Node Exporter
sudo systemctl enable --now node_exporter.service

echo "========================================"
echo " Node Exporter Status"
echo "========================================"

sudo systemctl status node_exporter.service --no-pager

echo "========================================"
echo " Installation completed!"
echo "========================================"

PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

echo "Node Exporter metrics:"
echo "http://$PUBLIC_IP:9100/metrics"