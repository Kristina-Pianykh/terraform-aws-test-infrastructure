resource "aws_security_group" "launch_instance" {
  name        = "launch-wizard"
  vpc_id      = var.vpc_id
  description = "Allow SSH and HTTP from the Internet"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }
}

resource "aws_security_group" "my-demo-lb" {
  name        = "my-demo-lb"
  vpc_id      = var.vpc_id
  description = "Allow HTTP from and to the Internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
}
