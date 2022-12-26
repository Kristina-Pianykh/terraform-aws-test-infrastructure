resource "aws_launch_configuration" "demo-config" {
  name             = "EC2-launch-asg"
  image_id         = var.ami_id
  instance_type    = "t2.micro"
  user_data_base64 = base64encode(var.instance_userdata)
  security_groups  = [aws_security_group.launch_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo-asg" {
  name                = "Autoscaling Group"
  health_check_type   = "ELB"
  vpc_zone_identifier = [for subnet in aws_subnet.subnet : subnet.id]
  #   desired_capacity     = 3
  max_size             = 3
  min_size             = 1
  force_delete         = true
  launch_configuration = aws_launch_configuration.demo-config.name
  target_group_arns    = [aws_lb_target_group.test-target-group.arn]
}

resource "aws_autoscaling_attachment" "test-attachment" {
  autoscaling_group_name = aws_autoscaling_group.demo-asg.id
  lb_target_group_arn    = aws_lb_target_group.test-target-group.arn
}

resource "aws_autoscaling_policy" "cpu-asg-policy" {
  name                   = "CPUAsgPolicy"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.demo-asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}
