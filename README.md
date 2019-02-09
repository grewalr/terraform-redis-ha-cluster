# Google Cloud Redis HA Cluster Terraform Template

This Terraform template makes it easy to launch a High-Availability Redis cluster to cache application data in memory.

Specifically, this repo provides a template to create a 3-node cluster with Redis Sentinel and Redis Server running on each node. Three Managed Instance Groups are used in order to enable creation of a multi-zonal cluster.

Redis Sentinel will promote a new master node to accept writes if the current master becomes unresponsive. Each VM will be deleted and replaced by its Managed Instance Group if the TCP healthcheck fails multiple times in a row.


## Usage

### Deploy Redis HA Cluster

```
terraform plan
terraform apply
```

### Deprovision Redis HA Cluster

```
terraform destroy
```


## Requirements

### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html)
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google)
- [terraform-provider-google-beta](https://github.com/terraform-providers/terraform-provider-google-beta)


## Install

### Terraform

You can download the latest Terraform binary here:
- https://releases.hashicorp.com/terraform/

Terraform init will fetch the required plugins
```
terraform init
```


## File structure
The project has the following folders and files:

- /config.tf: Creates a Cloud Storage bucket and uploads a startup script
- /firewall.tf: Creates firewall rules to allow healthcheck, communication within the cluster, and clients on the private network.
- /main.tf: Creates Instance templates and Managed Instance Groups
- /network.tf: Creates Static Private IP and TCP Healthcheck
- /README.md: this file
- /redis.sh.tpl: Template for startup script that installs and configures Redis
- /service_account.tf: Creates service account and grants permission to write StackDriver Logging and Metrics
- /startup.sh.tpl: Startup script that fetches Redis startup script
- /variables.tf: Variables - Edit this file before running apply.


## License

Apache License, Version 2.0

## Disclaimer

This is not an official Google project.

