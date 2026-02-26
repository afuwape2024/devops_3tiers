#create route table and routes
resource "aws_route_table" "web_subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0" # Route for internet-bound traffic
    gateway_id      = var.internet_gateway
  }
  tags = {
    Name = "web-rt"
  }
}
resource "aws_route_table_association" "web_subnet" {
  count = length(var.web_subnet_ids)
  subnet_id = var.web_subnet_ids[count.index]
  route_table_id = aws_route_table.web_subnet.id
}

