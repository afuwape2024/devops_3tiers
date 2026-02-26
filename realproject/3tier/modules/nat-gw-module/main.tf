#create app and database route table after the Nat-gateway
#create nat gateway for app subnet

resource "aws_eip" "nat_eip" {
  count  = length(var.web_subnet_ids)
  domain = "vpc"
}   
resource "aws_nat_gateway" "main_nat_gw" {
  count         = length(var.web_subnet_ids)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.web_subnet_ids[count.index]

  tags = {
    Name = "nat-gw-${count.index}"
  }
}

#===============================================================================
#===============================================================================
#=============================================================================
#create route table and routes for app subnet
#this route table allow traffic from with the VPC to the app subnet, but not from the internet 

resource "aws_route_table" "app_rt" {
  vpc_id = var.vpc_id
  count  = length(var.app_subnet_ids)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw[min(count.index, length(aws_nat_gateway.main_nat_gw) - 1)].id
  }

  tags = {
    Name = var.app_rt[count.index]
  }
}

resource "aws_route_table_association" "app_subnet" {
  count = length(var.app_subnet_ids)
  subnet_id = var.app_subnet_ids[count.index]
  route_table_id = aws_route_table.app_rt[count.index].id
}

#===============================================================================
#===============================================================================
#Adding database route table with no internet or eip_id

resource "aws_route_table" "database_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.database_rt
  }
}
resource "aws_route_table_association" "rt_database_subnet" {
  count = length(var.db_subnet_ids)
  subnet_id = var.db_subnet_ids[count.index]
  route_table_id = aws_route_table.database_rt.id
}