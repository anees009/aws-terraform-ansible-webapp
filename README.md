# Building a fully automated web-app using AWS, Terraform and Ansible

# Goal
This repository sets up:
* 1 web-server with Nginx reverse proxy and loadbalancing
* 2 app-servers with python app serving on port 8000
### The following AWS resources are also created in the process
* 1 Key-pair for ssh connections
* 1 VPC to isolate the network environment
* 2 security groups, 1 each for web-server and app-server
* 3 AWS EC2 instances 

# Setup Requirement
* Linux client containing
* [Terraform](https://www.terraform.io/) >= 0.14.7
* [Ansible](https://www.ansible.com/) >= 2.9.13
* python3
* AWS free tier account with credentials for IAM user having Admin Access 

# Project structure
```
$tree
.
├── ansible
│   ├── roles
│   │   ├── app_server
│   │   │   ├── files
│   │   │   │   └── server.py
│   │   │   └── tasks
│   │   │       └── main.yml
│   │   └── web_server
│   │       └── tasks
│   │           └── main.yml
│   └── site.yml
├── inventory.tmpl
├── main.tf
├── nginx.tmpl
├── outputs.tf
├── variables.tf
└── vpc.tf

```
# Usage
Clone the git repo \
Execute
```
# terraform init
# terraform plan
# terraform apply
```
Thats all!, the deployement will up and running in few seconds\
Outputs:
```
Public_IP = "<Public_IP_web-server>"
```
Now do 
```
$ for i in {1..10}; do curl http://<Public_IP_web-server>/; sleep 2; done
Hi there, I'm served from ip-10-0-0-225.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-233.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-225.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-233.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-225.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-233.us-east-2.compute.internal!
Hi there, I'm served from ip-10-0-0-225.us-east-2.compute.internal!
```
Destroy the infrastructure
```
# terraform destroy
```
# Repository structure
**main.tf** - contains general infrastructure description\
**vpc.tf** - contains vpc details\
**inventory.tmpl** - template file that dynamically creates ansible-inventory once ec2 instances are ready\
**nginx.tmpl** - template file that dynamically creates nginx.conf, to be used for reverse proxy\
**ansible/site.yml** - Ansible deployment file containing roles that will be deployed once infrasture is provisioned\
**ansible/roles/app_server/files/server.py** - Python web app to be deployed on app-servers

# Disclaimer

The idea here is to setup the working app with minimal effort (1 click), in doing so there are few security concerns that have been over looked and are never recomended in production.
* AWS private key is generated and stored in working dir (It is always adviced to never do this, instead bring your own key isolated from the environment)
