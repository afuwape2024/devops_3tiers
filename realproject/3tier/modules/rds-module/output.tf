output "database_mysql" {
    value = aws_db_instance.database_mysql_primary.id
}

output "database_mysql_read_replica" {
    value = aws_db_instance.database_mysql_read_replica.id
}