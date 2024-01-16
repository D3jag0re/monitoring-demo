## Basic 

The Basic demo will spin up 2 VMs, one to monitor, the other for running our monitoring stack. 
These will both be deployed in Azure via Terraform. 

## Configuration 

Inside basic/scripts there is a configuration bash script for each server.





## Manual Configuration (Follow only if not using the scripts)

Once you deploy the infra using Terraform, we can manually configure these two VMs using the following steps: 

### 1. Prepare 'stress' VM For Monitoring by installing Prometheus Node Exporter
Install and configure the Prometheus Node Exporter. This tool collects various system metrics that can be scraped by Prometheus. <br>
SSH into the machine <br>
Get the latest version of Node Exporter from https://prometheus.io/download/#node_exporter 

```
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
```

Extract 

```
tar xvfz node_exporter...tar.gz
```
Move it

```
sudo mv node_exporter-X.X.X.linux-amd64/node_exporter /usr/local/bin/
```

Create Service

```
sudo vi /etc/systemd/system/node_exporter.service
```

File should have the following contents:

```
[Unit]
Description=Prometheus Node Exporter

[Service]
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
```

Start and Enable Service

```
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
```

You can test by running the following and getting an output: 

```
curl http://localhost:9100/metrics 
```

And / or jump into "mon" VM and replace localhost with the private ip of "stress" VM to check proper connectivity

### 2. Prepare 'mon' VM by installing and configuring Prometheus

#### Download and install Prometheus 
SSH Into Machine

```
wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz
```

Extract 

```
tar xvfz prometheus-X.X.X.linux-amd64.tar.gz
```

Move it

```
sudo mv prometheus-X.X.X.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-X.X.X.linux-amd64/promtool /usr/local/bin/
```

#### Configure

Create directory to store config files 


```
sudo mkdir /etc/prometheus
```


Create 'prometheus.yml' configuration file 


```
sudo vi /etc/prometheus/prometheus.yml
```


A minimal example of what it should look like: 


```yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'vm-a'
    static_configs:
      - targets: ['vm_a_ip_address:9100']
```

#### Run Prometheus 

Start as background process


```
nohup prometheus --config.file=/etc/prometheus/prometheus.yml &
```


Verify it is running 


```
ps aux | grep prometheus
```

### 3. Install and configure Grafana on 'mon'

#### Install from APT
This will allow grana to be updated when running apt-get update. Otherwise will need to be manually updated. 

Install prerequisite packages

```
sudo apt-get install -y apt-transport-https software-properties-common wget
```

Import CGP Key

```
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

To add a repository for stable releases, run the following command:

```
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

Run the following command to update the list of available packages:

```
sudo apt-get update
```

Install OSS release (replace grafana with grafana-enterpise for enterprise version)

```
sudo apt-get install grafana
```


#### Start The Service

Grafana can be started as a service using the systemctl command.

```
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```

Verify that Grafana is running by checking its status:

```
sudo systemctl status grafana-server
```

Optional: If you want Grafana to start at boot: 

```
sudo systemctl enable grafana-server.service
```

By default, Grafana listens on port 3000. You can access the Grafana web interface by opening a web browser and navigating to http://vm-b-ip-address:3000. Replace vm-b-ip-address with the actual IP address or hostname of VM-B.

### 4. Configure Grafana Web UI 

Login to the web interface using default credentials (admin/admin) and change pass

#### Add Prometheus as a Datasource

Go to Data sources and Add > Prometheus <br>
When providing the URL make sure you use where Prometheus is running (not the node exporter). In this case: 

```
http://localhost:9090
```

Click Save&Test

#### Build Dashboard 
