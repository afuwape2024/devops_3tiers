output "web-security_group" {
  value = aws_security_group.web-security_group.id
}

output "app_security_group" {
  value = aws_security_group.app_security_group.id
}

output "database_security_group" {
  value = aws_security_group.database_security_group.id
}