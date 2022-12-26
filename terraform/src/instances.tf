locals {
  instance-userdata = <<EOF
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
}

resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  count                       = var.instance_count
  user_data_base64            = base64encode(local.instance-userdata)
  vpc_security_group_ids      = [aws_security_group.launch_instance.id]
  associate_public_ip_address = true
}
