#!/bin/bash
# Config Script for the 'mon' VM

# Download and Install Prometheus

echo "Downloading and installing Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz

# Extract

tar xvfz prometheus-2.48.1.linux-amd64.tar.gz

# Move It 

sudo mv prometheus-2.48.1.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.48.1.linux-amd64/promtool /usr/local/bin/

### Configure Prometheus ### 

echo "Configuring Prometheus..."

# Create directory to store config files 

sudo mkdir -p /etc/prometheus

# Create 'prometheus.yml' configuration file 

cat <<EOF | sudo tee /etc/prometheus/prometheus.yml > /dev/null || { echo "Failed to create Prometheus configuration file"; exit 1; }
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'vm-a'
    static_configs:
      - targets: ['vm_a_ip_address:9100']
EOF

# Start as background process 

nohup prometheus --config.file=/etc/prometheus/prometheus.yml & 

### Grafana ### 

# Install prerequisite packages 

echo "Installing prerequisite packages"

sudo apt-get install -y apt-transport-https 
software-properties-common wget

# Import CGP Key

echo "Importing CGP Key"

mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | 
sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add repo for stable release 

echo "Adding stable release repo"

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update

# Install OSS Release (replace grafana with grafana-enterpise for enterprise version)

echo "Installing OSS Release..."

sudo apt-get install grafana -y 

# Start The Service 

echo "Starting the Service" 

sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server.service

