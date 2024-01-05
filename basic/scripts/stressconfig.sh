#!/bin/bash
# Config Script for the 'stress' VM
# This will install and configure Prometheus node exporter 

# Download 
echo "Downloading Prometheus Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz

# Extract 
echo "Extracting Prometheus Node Exporter..."
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz

# Move it
echo "Moving Prometheus Node Exporter to /usr/local/bin/..."
sudo mv node_exporter-X.X.X.linux-amd64/node_exporter /usr/local/bin/

#Create Service 
echo "Creating systemd service..."
file_content="[Unit]
Description=Prometheus Node Exporter

[Service]
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target"

echo "$file_content" > /etc/systemd/system/node_exporter.service

# Start and Enable Service 
echo "Starting and enabling Prometheus Node Exporter service..."
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "Prometheus Node Exporter successfully installed and configured!"