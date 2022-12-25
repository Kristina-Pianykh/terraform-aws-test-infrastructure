# resource "aws_launch_configuration" "demo-config" {
#   #   description      = "Launch Configuration for EC2s managed by Auto-Scaling"
#   name             = "EC2-launch-asg"
#   image_id         = var.ami_id
#   instance_type    = "t2.micro"
#   user_data_base64 = base64encode(var.instance_userdata)
#   security_groups  = [aws_security_group.launch_instance.id]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "demo-asg" {
#   name              = "Autoscaling Group"
#   health_check_type = "ELB"
#   #   termination_policies = ["OldestInstance"]
#   vpc_zone_identifier  = [for subnet in aws_subnet.subnet : subnet.id]
#   desired_capacity     = 2
#   max_size             = 4
#   min_size             = 1
#   force_delete         = true
#   launch_configuration = aws_launch_configuration.demo-config.name
#   target_group_arns    = [aws_lb_target_group.test-target-group.arn]
# }

# resource "aws_autoscaling_attachment" "test-attachment" {
#   autoscaling_group_name = aws_autoscaling_group.demo-asg.id
#   lb_target_group_arn    = aws_lb_target_group.test-target-group.arn
# }
