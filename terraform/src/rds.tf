resource "aws_db_instance" "demo_db" {
  allocated_storage       = 20
  identifier              = "my-sql-demo-db"
  db_name                 = "mydb"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  backup_retention_period = 7
  # kms_key_id 
  port                   = var.mysql_db_port
  publicly_accessible    = true
  storage_type           = "gp2"
  vpc_security_group_ids = [aws_security_group.mysql_db_security_group.id]
  deletion_protection    = false
}
