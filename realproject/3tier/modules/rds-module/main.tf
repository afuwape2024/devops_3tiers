resource "aws_db_subnet_group" "database_mysql" {
  name       = "${var.database_mysql}-subnet-group"
  subnet_ids = var.db_subnet

  tags = {
    Name = "database-mysql-primary"
  }
}

resource "aws_db_instance" "database_mysql_primary" {
  identifier              = "database-mysql-primary"

  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.database_instance_class

  username                = var.database_username
  password                = var.database_password
  db_name                 = var.database_mysql

  allocated_storage       = 20
  storage_type            = "gp3"
  storage_encrypted       = false 

  vpc_security_group_ids  = [var.database_security_group]
  db_subnet_group_name    = aws_db_subnet_group.database_mysql.name

  publicly_accessible     = false
  multi_az                = true
  backup_retention_period = 7
  deletion_protection     = false 
  skip_final_snapshot     = true

  performance_insights_enabled = false

  tags = {
    Name = "${var.database_mysql}-primary"
  }
}

resource "aws_db_instance" "database_mysql_read_replica" {
  identifier          = "database-mysql-primary-read-replica"

  engine              = "mysql"
  instance_class      = var.database_instance_class

  replicate_source_db = aws_db_instance.database_mysql_primary.id

  publicly_accessible = false
  storage_encrypted   = false
  skip_final_snapshot = true

  vpc_security_group_ids = [var.database_security_group]
  db_subnet_group_name   = aws_db_subnet_group.database_mysql.name

  depends_on = [
    aws_db_instance.database_mysql_primary
  ]

  tags = {
    Name = "database-mysql-primary-read-replica"
  }
}