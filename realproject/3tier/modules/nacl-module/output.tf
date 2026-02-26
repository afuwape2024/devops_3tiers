output "web_nacl" {
  value = aws_network_acl.web_nacl.id
}
output "app_nacl" {
  value = aws_network_acl.app_nacl.id
}
output "db_nacl" {
  value = aws_network_acl.db_nacl.id
}