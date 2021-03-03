# Building a fully automated web-app using AWS, Terraform and Ansible

# Pre-requisits / Enivornment
Linux client
Install Terraform v0.14.7 or higher
Install ansible 2.9.13 or higher
AWS free tier account with credentials for IAM user having Admin Access

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

7 directories, 9 files```

dddd





