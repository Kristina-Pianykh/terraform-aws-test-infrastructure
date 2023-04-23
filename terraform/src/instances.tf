# resource "aws_instance" "data_import" {
#   ami = var.ami_id
#   # select one subnet from aws_subnet.subnet
#   subnet_id     = aws_subnet.subnet["private-subnet-az-a"].id
#   instance_type = var.data_import_instance_type
#   launch_template {
#     id      = aws_launch_template.data_import_ec2.id
#     version = "$Latest"
#   }
#   tags = {
#     Name = "data-import"
#   }
# }

# resource "aws_launch_template" "data_import_ec2" {
#   name = "data_import_ec2_template"

#   #   block_device_mappings {
#   #     device_name = "/dev/sdf"

#   #     ebs {
#   #       volume_size = 20
#   #     }
#   #   }

#   #   capacity_reservation_specification {
#   #     capacity_reservation_preference = "open"
#   #   }

#   #   cpu_options {
#   #     core_count       = 4
#   #     threads_per_core = 2
#   #   }

#   #   credit_specification {
#   #     cpu_credits = "standard"
#   #   }

#   image_id = var.ami_id

#   instance_initiated_shutdown_behavior = "terminate"

#   instance_market_options {
#     market_type = "spot"
#   }

#   instance_type = var.data_import_instance_type

#   monitoring {
#     enabled = true
#   }

#   #   network_interfaces {
#   #     associate_public_ip_address = true
#   #   }

#   # vpc_security_group_ids = ["sg-12345678"] # This is the security group that allows SSH access to the instance
#   # security_group_names =
#   user_data = filebase64("${path.module}/import_data.sh")
# }
