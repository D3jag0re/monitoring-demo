# monitoring-demo

This is to demonstrate monitoring / observability using Prometheus / Grafana 
Note all of this is being deployed in Azure from our local machine.

## Basic 

The Basic demo will spin up 2 VMs:
- stress : This is the VM we will be collecting metrics from
- mon : This is the VM we will be running Prometheus and Grafana on 
These will both be deployed in Azure via Terraform. I have also provided configuration bash scripts for each VM.  
