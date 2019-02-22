# Google Cloud Redis HA Cluster Terraform Templates

These Terraform templates launch a High-Availability Redis cluster with auto-healing and monitoring built in. Redis is very useful for caching application data in memory and can also be used as a message broker.

The core template creates a 3-node cluster with Redis Sentinel and Redis Server running on each node. Three Managed Instance Groups are used in order to enable creation of a multi-zonal cluster.


## Description

The template writes an installation script to a Cloud Storage Bucket. The installation script installs Redis Server, Redis Sentinel, and StackDriver Agent. Instance Templates are configured such that any Instance created from the template will download and runs the installation script at startup. Managed Instance Groups use an Instance Template to create cluster member instances and replace each instance that becomes unhealthy.


## Failover Characteristics

Systemd will restart Redis if the process is stopped on an individual instance.

Redis Sentinel will promote a new master node to accept writes if the current master becomes unresponsive.

Managed Instance Group runs a TCP health check and will replace any instance that is unresponsive multiple times in a row.

## Monitoring with StackDriver

StackDriver Agent Redis Plugin exports the following metrics:
- Blocked clients
- Command count
- Connected clients
- Connection count
- Expired keys
- Lua memory usage
- Memory usage
- PubSub channels
- PubSub patterns
- Slave connections
- Unsaved changes
- Uptime

It also exports CPU, Disk and Network metrics.

The metrics can be viewed using [StackDriver Metrics Explorer](https://app.google.stackdriver.com/metrics-explorer). Select "GCE VM Instance" as the Resource Type.

Redis metrics are given URIs begin with "agent.googleapis.com/redis/" and can be filtered by cluster using the "cluster_name" metadata label added by this template.

StackDriver can be used to create dashboards or define alerts, and has built-in integration with [PagerDuty](https://app.google.stackdriver.com/settings/accounts/notifications/pagerduty), [Slack](https://app.google.stackdriver.com/settings/accounts/notifications/slack) and [SMS](https://app.google.stackdriver.com/settings/accounts/notifications/sms).


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

- README.md: this file
- [common/main.tf](common/main.tf): Creates Service Account, Cloud Storage Bucket, Firewall Rules and grants permissions to the Service Account
- common/variables.tf: Variables for Firewall Rules
- [healthcheck/main.tf](healthcheck/main.tf): Creates TCP Healthcheck
- healthcheck/variables.tf: Variables for TCP Healthcheck
- [template/main.tf](template/main.tf): Creates Instance templates, Managed Instance Groups, Static Private IP, Startup Script
- [template/redis.sh.tpl](template/redis.sh.tpl): Template for startup script to install and configure Redis Server, Redis Sentinel and StackDriver Agent
- template/startup.sh.tpl: Startup script that fetches Redis startup script
- template/variables.tf: Variables - Variables for creating Redis Cluster


## License

Apache License, Version 2.0

## Disclaimer

This is not an official Google project.

