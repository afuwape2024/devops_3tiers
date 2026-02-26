# When creating the security for the provision 
# strict ports are opens and minimum access was given 

resource "aws_security_group" "web-security_group" {
  name        = "web-security_group"
  description = "Allow HTTP from Internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security_group"
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app-sg"
  description = "Allow traffic only from Web SG"
  vpc_id      = var.vpc_id

  # App receives traffic only from Web SG
  ingress {
    description     = "App traffic from Web SG"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web-security_group.id]
  }

  # SSH only from Web security group
  ingress {
    description     = "SSH from Web SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web-security_group.id]
  }

  egress {
    description = "Allow outbound to DB and internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_security_group"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "database-sg"
  description = "Allow MySQL only from App SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from App SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_security_group.id]
  }

  # For RDS, egress can remain open or be restricted
  egress {
    description = "Allow outbound responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database_security_group"
  }
}