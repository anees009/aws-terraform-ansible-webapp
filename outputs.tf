### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  web-server-ip = aws_instance.web-server.public_ip,
  web-server-id = aws_instance.web-server.id,
  app-server-ip = module.ec2_cluster1.public_ip,
  app-server-id = module.ec2_cluster1.id,
 }
 )
 filename = "inventory"
}


### The nginx reverse proxy config file
resource "local_file" "nginx-conf" {
 content = templatefile("nginx.tmpl",
 {
  app-server-ip = module.ec2_cluster1.public_ip,
 }
 )
 filename = "nginx.conf"
}