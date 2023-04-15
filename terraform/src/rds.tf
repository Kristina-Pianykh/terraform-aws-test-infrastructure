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
    command = """
    db_endpoint=${split(":", aws_db_instance.demo_db.endpoint)[0]}
    mysql \
      -h $${db_endpoint} \
      -u ${var.db_username} \
      -P ${var.mysql_db_port} \
      --password=${var.db_password} '
      -e 'USE mydb; CREATE TABLE ${var.db_table_name} (hero_id int, attribute_id int, attribute_value int);'
    split -C 1024m -d ${var.local_data_file_name} data.part_
    mysqlimport  --local \
      --compress \
      --user=${var.db_username} \
      --password=${var.db_password} \
      --host=$${db_endpoint} \
      --fields-terminated-by=',' mydb ${var.db_table_name}.part_*
    """
  }
}
