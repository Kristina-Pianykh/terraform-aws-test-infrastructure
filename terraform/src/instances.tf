# resource "aws_instance" "app_server" {
#   ami                         = var.ami_id
#   instance_type               = var.instance_type
#   count                       = var.instance_count
#   user_data_base64            = base64encode(var.instance_userdata)
#   vpc_security_group_ids      = [aws_security_group.launch_instance.id]
#   associate_public_ip_address = true
# }
