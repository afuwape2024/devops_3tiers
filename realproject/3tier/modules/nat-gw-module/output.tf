output "nat_gateway_id" {
        value = aws_nat_gateway.main_nat_gw[*].id
}
output "eip_id" {
        value = aws_eip.nat_eip[*].id
}
output "app_and_dbroute_table" {
    value = aws_route_table.app_rt[*].id
}