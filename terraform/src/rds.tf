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
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.subnet : subnet.id]
}

resource "null_resource" "db_setup" {

  provisioner "local-exec" {
    command = "mysql -h ${split(":", aws_db_instance.demo_db.endpoint)[0]} -u ${var.db_username} -P ${var.mysql_db_port} -p ${var.db_password} ${aws_db_instance.demo_db.db_name} -e 'CREATE TABLE hero_attribute (hero_id int, attribute_id int, attribute_value int);'"
  }
}
