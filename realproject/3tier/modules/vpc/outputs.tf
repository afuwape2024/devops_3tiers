output "new_vpc" {
  value = aws_vpc.new_vpc.id
}
output "web_subnet" {
  value = aws_subnet.web_subnet[*].id
}
output "app_subnet" {
  value = aws_subnet.app_subnet[*].id
}
output "db_subnet" {
  value = aws_subnet.db_subnet[*].id
}
output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}
output "web_route_table" {
  value = aws_route_table.web_subnet.id
}
output "app_and_dbroute_table" {
  value = aws_route_table.app_and_db_subnet.id
}
 
output "web_nacl1" {
  value = aws_network_acl.web_nacl1.id
}
output "app_nacl1" {
  value = aws_network_acl.app_nacl1.id
}

