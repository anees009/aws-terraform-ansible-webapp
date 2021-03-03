# Building a fully automated web-app using AWS, Terraform and Ansible

# Details
This repository sets up:
* 1 web-server with Nginx reverse proxy and loadbalancing
* 2 app-servers with python app serving on port 8000

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
Now do 
```
# curl http://<Public_IP_web-server/
```



