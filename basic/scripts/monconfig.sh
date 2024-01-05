#!/bin/bash
# Config Script for the 'mon' VM

# Download and Install Prometheus

echo "Downloading and installing Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz

# Extract

tar xvfz prometheus-X.X.X.linux-amd64.tar.gz

# Move It 

sudo mv prometheus-X.X.X.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-X.X.X.linux-amd64/promtool /usr/local/bin/

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

