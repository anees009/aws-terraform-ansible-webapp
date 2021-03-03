provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-2"
}

module "security_group1" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "app-server-sg"
  description = "Temporary security group for appserver"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      description = "Port opened for webserver reverse proxy"
      cidr_blocks = "${aws_instance.web-server.public_ip}/32"
    },
    ]
}

module "security_group2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "web-server-sg"
  description = "Temporary security group for webserver"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "ec2_cluster1" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "app-servers"
  instance_count         = 2

  ami                    = "ami-01aab85a5e4a5a0fe"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  monitoring             = true
  vpc_security_group_ids = [module.security_group1.this_security_group_id]
  subnet_id              = aws_subnet.terraform_vpc.id

}

resource "aws_instance" "web-server" {
  ami           = "ami-01aab85a5e4a5a0fe"
  instance_type = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [module.security_group2.this_security_group_id]
  subnet_id = aws_subnet.terraform_vpc.id
  tags = {
    Name = "web-server"
  }
  }

resource "null_resource" "cluster" {
  count = 2
  triggers = {
    cluster_instance_ips = element(module.ec2_cluster1.private_ip, count.index)
  }
  connection {
    host = element(module.ec2_cluster1.public_ip, count.index)
    user        = "ec2-user"
    type        = "ssh"
    private_key = tls_private_key.testingkey.private_key_pem
    timeout     = "10m"
  }
  provisioner "remote-exec" {
    inline = ["sudo yum install git -y", "sudo yum install python3 -y", "echo Done!"]
    }
}

resource "null_resource" "web-server" {
  triggers = {
    instance_ip = aws_instance.web-server.public_ip
  }
  connection {
    host = aws_instance.web-server.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = tls_private_key.testingkey.private_key_pem
    timeout     = "10m"
  }
  provisioner "remote-exec" {
    inline = ["sudo yum install git -y", "sudo yum install python3 -y", "echo Done!"]
    }
}

resource null_resource "ansible_deploy_app" {
  depends_on = [
    null_resource.web-server, null_resource.cluster, local_file.terraform_key
  ]

  provisioner "local-exec" {
    command = "sleep 45; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key terraform_app.pem -i inventory ansible/site.yml"
  }
}

resource "tls_private_key" "testingkey" {
  algorithm   = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "generated_key" {
  key_name   = "testingkey_aws"
  public_key = tls_private_key.testingkey.public_key_openssh
}


resource "local_file" "terraform_key" { 
  filename = "${path.module}/terraform_app.pem"
  content = tls_private_key.testingkey.private_key_pem
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/terraform_app.pem"
}
}
output "Public_IP" {
  value = aws_instance.web-server.public_ip
  description = "The Public IP address of the main web-server."
}
