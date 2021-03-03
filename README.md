# Building a fully automated web-app using AWS, Terraform and Ansible

# Details
This repository sets up:
* 1 web-server with Nginx reverse proxy and loadbalancing
* 2 app-servers with python app serving on port 8000
The following AWS resources are also created in the process
* 1 Key-pair for ssh connections
* 1 VPC to isolate the network environment
* 2 security groups, 1 each for web-server and app-server
* 

# Setup
* Linux client
* [Terraform](https://www.terraform.io/) >= 0.14.7
* [Ansible](https://www.ansible.com/) >= 2.9.13
* python3
* AWS free tier account with credentials for IAM user having Admin Access
* AWS default VPC 

# Project structure
```$ tree
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
└── variables.tf

7 directories, 9 files
```

# Usage
Clone the git repo
Execute
```
# terraform init
# terraform plan
# terraform apply
```
Outputs
Outputs:
```
Public_IP = "<Public_IP_web-server>"
```
Now do 
```
# curl http://<Public_IP_web-server>/
Hi there, I'm served from ip-10-0-0-233.us-east-2.compute.internal!
# curl http://<Public_IP_web-server>/
Hi there, I'm served from ip-10-0-0-225.us-east-2.compute.internal!
```
```



