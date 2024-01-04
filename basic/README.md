## Basic 

The Basic demo will spin up 2 VMs, one to monitor, the other for running our monitoring stack. 
These will both be deployed in Azure via Terraform. 

Note: nic not being dissasociated with VM before being destroyed. fix so single destroy cn be used. depends_on ? 