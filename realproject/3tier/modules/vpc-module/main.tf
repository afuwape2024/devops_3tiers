
resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.new_vpc
  } 
}











