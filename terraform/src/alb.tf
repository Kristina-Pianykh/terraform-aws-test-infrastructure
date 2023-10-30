resource "aws_lb" "application_alb" {
  name               = "AppFrontedALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-demo-lb.id]
  subnets            = [for subnet in aws_subnet.subnet : subnet.id]
}

resource "aws_lb_target_group" "app_fronted_target_group" {
  name     = "AppFrontedTargetGroup"
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

resource "aws_lb_listener" "application_alb_http_listener" {
  load_balancer_arn = aws_lb.application_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_fronted_target_group.arn
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


# resource "aws_lb" "cluster_fronted_alb" {
#   name               = "ClusterFrontedALB"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.my-demo-lb.id]
#   subnets            = [for subnet in aws_subnet.subnet : subnet.id]
# }

# resource "aws_lb_target_group" "cluster_fronted_target_group" {
#   name     = "ClusterFrontedTargetGroup"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id

#   health_check {
#     path                = "/"
#     port                = var.health_check_port
#     healthy_threshold   = 2
#     unhealthy_threshold = 5
#     interval            = 5
#     timeout             = 4
#   }
# }

# resource "aws_lb_listener" "cluster_fronted_alb_http_listener" {
#   load_balancer_arn = aws_lb.cluster_fronted_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.cluster_fronted_target_group.arn
#   }
# }
