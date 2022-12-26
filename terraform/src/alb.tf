resource "aws_lb" "DemoALB" {
  name               = "ALBdemo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-demo-lb.id]
  subnets            = [for subnet in aws_subnet.subnet : subnet.id]
}

resource "aws_lb_target_group" "test-target-group" {
  name     = "my-first-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = var.health_check_port
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 5
    timeout             = 4
  }
}

resource "aws_lb_target_group_attachment" "test-3-instances" {
  target_group_arn = aws_lb_target_group.test-target-group.arn
  count            = var.instance_count
  target_id        = aws_instance.app_server[count.index].id
  port             = 80
}

resource "aws_lb_listener" "demo-http-listener" {
  load_balancer_arn = aws_lb.DemoALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-target-group.arn
  }
}

# resource "aws_lb_listener" "demo-https-listener" {
#   load_balancer_arn = aws_lb.DemoALB.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.test-target-group.arn
#   }
# }
