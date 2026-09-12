#!/bin/bash

set -e

echo "========================================"
echo " Installing Prometheus"
echo "========================================"

# Update system
sudo apt update

# Create Prometheus user
if ! id prometheus &>/dev/null; then
    sudo useradd --no-create-home --shell /bin/false prometheus
fi

# Create required directories
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download Prometheus
cd /tmp

wget -q https://github.com/prometheus/prometheus/releases/download/v3.4.0/prometheus-3.4.0.linux-amd64.tar.gz

# Extract
tar xvf prometheus-3.4.0.linux-amd64.tar.gz

# Enter Prometheus directory
cd prometheus-3.4.0.linux-amd64

# Install Prometheus binaries
sudo mv prometheus promtool /usr/local/bin/

# Install configuration
sudo mv prometheus.yml /etc/prometheus/

# Set ownership
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

echo "========================================"
echo " Creating Prometheus systemd service"
echo "========================================"

sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple

ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable and start Prometheus
sudo systemctl enable --now prometheus

echo "========================================"
echo " Prometheus Status"
echo "========================================"

sudo systemctl status prometheus --no-pager

echo "========================================"
echo " Prometheus installation completed!"
echo "========================================"

echo "Prometheus URL:"
echo "http://<YOUR-EC2-PUBLIC-IP>:9090"