
resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.new_vpc
  } 
}

resource "aws_subnet" "web_subnet" {
  count = length(var.web_subnet_cidr_block)
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = var.web_subnet_cidr_block[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.new_vpc}-web-${count.index}"
  }
}

resource "aws_subnet" "app_subnet" {
  count = length(var.app_subnet_cidr_block)
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = var.app_subnet_cidr_block[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.new_vpc}-app-${count.index}"
  }
}

resource "aws_subnet" "db_subnet" {
  count = length(var.db_subnet_cidr_block)
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = var.db_subnet_cidr_block[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.new_vpc}-db-${count.index}"
  }
}

#===============================================================================
#create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = "${var.new_vpc}-igw"
  }
}   

#===============================================================================
#create route table and routes
resource "aws_route_table" "web_subnet" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block      = "0.0.0.0/0" # Route for internet-bound traffic
    gateway_id      = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.new_vpc}-web-rt"
  }
}
resource "aws_route_table_association" "web_subnet" {
  count = length(var.web_subnet_cidr_block)
  subnet_id = aws_subnet.web_subnet[count.index].id
  route_table_id = aws_route_table.web_subnet.id
}

#===============================================================================
#create route table and routes for app subnet
#this route table allow traffic from with the VPC to the app subnet, but not from the internet 
resource "aws_route_table" "app_and_db_subnet" {
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    Name = "${var.new_vpc}-app-rt"
  }
}
resource "aws_route_table_association" "app_and_db_subnet" {
  count = length(var.app_subnet_cidr_block)
  subnet_id = aws_subnet.app_subnet[count.index].id
  route_table_id = aws_route_table.app_and_db_subnet.id
}
resource "aws_route_table_association" "app_and_db_subnetsubnet" {
  count = length(var.db_subnet_cidr_block)
  subnet_id = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.app_and_db_subnet.id
}

#===============================================================================
#===============================================================================
#===============================================================================
#create nat gateway for app subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}   
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.web_subnet[0].id

  tags = {
    Name = "${var.new_vpc}-nat-gw"
  }
}
resource "aws_route_table" "private_app_subnet" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.new_vpc}-private-app-rt"
  }
}

#==============================================================================
#===============================================================================
#===============================================================================
#create nacl for web subnet
resource "aws_network_acl" "web_nacl1" {
    vpc_id = aws_vpc.new_vpc.id
   # subnet_ids = [var.public_subnet] # Associate with the subnet

  # Inbound rule: Allow all traffic from within the VPC CIDR (rule 100)
  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = aws_vpc.new_vpc.cidr_block #if you want to allow from VPC only
    from_port  = 22
    to_port    = 22
  }
  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0" #if you want to allow from anywhere
    from_port  = 80
    to_port    = 80
  }
  ingress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0" #if you want to allow from anywhere
    from_port  = 443
    to_port    = 443
  }
  ingress {
    rule_no    = 130
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0" #if you want to allow from anywhere
    from_port  = 0
    to_port    = 0
  }

  # Outbound rule: Allow all outbound traffic (rule 100)
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16" # send traffic to local VPC
    from_port  = 0
    to_port    = 0
  }
  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.new_vpc}-web-nacl1"
  }
}
#associate network ACL with web subnets
resource "aws_network_acl_association" "web_assoc" {
    count          = length(var.web_subnet_cidr_block)
    subnet_id      = aws_subnet.web_subnet[count.index].id
    network_acl_id = aws_network_acl.web_nacl1.id
}


#=========================================================================
#network ACL for private app subnet
resource "aws_network_acl" "app_nacl1" {
    vpc_id = aws_vpc.new_vpc.id

    # Inbound rule: Allow traffic only from web subnets
    ingress {
        rule_no    = 100
        action     = "allow"
        protocol   = "tcp"
        cidr_block = var.web_subnet_cidr_block[0]
        from_port  = 3306
        to_port    = 3306
    }
    ingress {
        rule_no    = 101
        action     = "allow"
        protocol   = "tcp"
        cidr_block = var.web_subnet_cidr_block[1]
        from_port  = 3306
        to_port    = 3306
    }

    egress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        cidr_block = aws_vpc.new_vpc.cidr_block
        from_port  = 0
        to_port    = 0      
    }
    tags = {
      "Name" = "${var.new_vpc}-app-nacl"
      }
}

#associate network ACL with app subnets
resource "aws_network_acl_association" "app_assoc" {
    count          = length(var.app_subnet_cidr_block)
    subnet_id      = aws_subnet.app_subnet[count.index].id
    network_acl_id = aws_network_acl.app_nacl1.id
}

#=========================================================================
#network ACL for private DB subnet
resource "aws_network_acl" "db_nacl1" {
    vpc_id = aws_vpc.new_vpc.id

    # Inbound rule: Allow traffic only from app subnets
    ingress {
        rule_no    = 100
        action     = "allow"
        protocol   = "tcp"
        cidr_block = var.app_subnet_cidr_block[0]
        from_port  = 3306
        to_port    = 3306
    }
    ingress {
        rule_no    = 101
        action     = "allow"
        protocol   = "tcp"
        cidr_block = var.app_subnet_cidr_block[1]
        from_port  = 3306
        to_port    = 3306
    }

    egress {
        rule_no    = 100
        action     = "allow"
        protocol   = "-1"
        cidr_block = aws_vpc.new_vpc.cidr_block
        from_port  = 0
        to_port    = 0      
    }
    tags = {
      "Name" = "${var.new_vpc}-db-nacl"
      }
}

#associate network ACL with db subnets
resource "aws_network_acl_association" "db_assoc" {
    count          = length(var.db_subnet_cidr_block)
    subnet_id      = aws_subnet.db_subnet[count.index].id
    network_acl_id = aws_network_acl.db_nacl1.id
}









