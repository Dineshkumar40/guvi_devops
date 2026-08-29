#!/bin/bash

set -e

echo "======================================"
echo " Installing Jenkins on Ubuntu EC2"
echo "======================================"

# Update packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Java and required packages
echo "Installing Java..."
sudo apt-get install -y fontconfig openjdk-21-jre

# Verify Java
java -version

# Add Jenkins repository key
echo "Adding Jenkins repository..."

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package lists
sudo apt-get update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# Start Jenkins
echo "Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check Jenkins status
echo "Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo ""
echo "======================================"
echo " Jenkins installation completed!"
echo "======================================"

# Get EC2 Public IPv4 using IMDSv2
echo "====================Fetching EC2 Public IPv4...===================="

TOKEN=$(curl -s -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

PUBLIC_IP=$(curl -s \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

echo ""
echo "Jenkins URL:"
echo "http://$PUBLIC_IP:8080"

echo ""
echo "Initial Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "======================================"