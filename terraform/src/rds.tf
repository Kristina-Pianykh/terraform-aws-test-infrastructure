resource "aws_db_instance" "demo_db" {
  allocated_storage       = 20
  identifier              = "my-sql-demo-db"
  db_name                 = var.db_name
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  backup_retention_period = 7
  port                    = var.mysql_db_port
  publicly_accessible     = true
  storage_type            = "gp2"
  vpc_security_group_ids  = [aws_security_group.mysql_db_security_group.id]
  deletion_protection     = false
  db_subnet_group_name    = aws_db_subnet_group.default.name
  parameter_group_name    = aws_db_parameter_group.custom.name

  depends_on = [
    aws_lambda_function.log_events_lambda
  ]
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.subnet : subnet.id]
}

resource "aws_db_parameter_group" "custom" {
  name   = "${var.db_name}-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "true"
    # apply_method = "pending-reboot"
  }
}
