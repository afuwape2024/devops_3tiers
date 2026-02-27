resource "aws_network_acl" "web_nacl" {
  vpc_id = var.vpc_id

  # Inbound HTTP allowed
  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 80
    to_port    = 80
  }

  # Inbound HTTPS
  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 443
    to_port    = 443
  }

  # Inbound Ephemeral (return traffic)
  ingress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  # allow the SSH Inbound
  ingress {
    rule_no    = 130
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 22
    to_port    = 22
  }

  # Outbound HTTP
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 80
    to_port    = 80
  }

  # Outbound HTTPS
  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 443
    to_port    = 443
  }

  # Outbound Ephemeral
  egress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.outside_cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "web_nacl" }
}

resource "aws_network_acl_association" "web_assoc" {
  count          = length(var.web_subnet_ids)
  subnet_id      = var.web_subnet_ids[count.index]
  network_acl_id = aws_network_acl.web_nacl.id
}

resource "aws_network_acl" "app_nacl" {
  vpc_id = var.vpc_id

  # Allow HTTP from Web subnets
  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[0]
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[1]
    from_port  = 80
    to_port    = 80
  }

  # Allow Ephemeral from Web (return traffic)
  ingress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[0]
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    rule_no    = 130
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[1]
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound to DB
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.db_subnet_cidr_block[0]
    from_port  = 3306
    to_port    = 3306
  }

  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.db_subnet_cidr_block[1]
    from_port  = 3306
    to_port    = 3306
  }

  # Outbound Ephemeral to Web
  egress {
    rule_no    = 120
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[0]
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    rule_no    = 130
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.web_subnet_cidr_block[1]
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "app-nacl" }
}

resource "aws_network_acl_association" "app_assoc" {
  count          = length(var.app_subnet_ids)
  subnet_id      = var.app_subnet_ids[count.index]
  network_acl_id = aws_network_acl.app_nacl.id
}

resource "aws_network_acl" "db_nacl" {
  vpc_id = var.vpc_id

  # Allow MySQL from App subnets
  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.app_subnet_cidr_block[0]
    from_port  = 3306
    to_port    = 3306
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.app_subnet_cidr_block[1]
    from_port  = 3306
    to_port    = 3306
  }

  # Allow Ephemeral (DB → App return)
  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.app_subnet_cidr_block[0]
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    cidr_block = var.app_subnet_cidr_block[1]
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "db-nacl" }
}

resource "aws_network_acl_association" "db_assoc" {
  count          = length(var.db_subnet_ids)
  subnet_id      = var.db_subnet_ids[count.index]
  network_acl_id = aws_network_acl.db_nacl.id
}