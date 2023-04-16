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
    interpreter = [
      "/bin/bash", "-c"
    ]
    command = <<EOT
    echo '${path.module}'
    ls
    ./import_data.sh -u ${var.db_username} -p ${var.db_password} -h ${split(":", aws_db_instance.demo_db.endpoint)[0]} -d ${aws_db_instance.demo_db.db_name} -f ${var.local_data_file_name} -t ${var.db_table_name} -P ${var.mysql_db_port}"""
  EOT
  }
}
