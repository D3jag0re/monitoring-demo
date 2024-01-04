# monitoring-demo

This is to demonstrate monitoring / observability using Prometheus / Grafana 
Note all of this is being deployed in Azure from our local machine.

## Basic 

The Basic demo will spin up 2 VMs:
- stress : This is the VM we will be collecting metrics from
- mon : This is the VM we will be running Prometheus and Grafana on 
These will both be deployed in Azure via Terraform. 

## Manual Configuration 

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



### 3. Install and configure Grafana on 'mon'

### 4. Configure Grafana Web UI 