resource "aws_subnet" "web_subnet" {
  count = length(var.subnet_config.web_subnet_cidr_block)
  vpc_id = var.vpc_id
  cidr_block = var.subnet_config.web_subnet_cidr_block[count.index]
  availability_zone = element(var.subnet_config.availability_zones, count.index)

  tags = {
    Name = "web-${count.index}"
  }
}

resource "aws_subnet" "app_subnet" {
  count = length(var.subnet_config.app_subnet_cidr_block)
  vpc_id = var.vpc_id
  cidr_block = var.subnet_config.app_subnet_cidr_block[count.index]
  availability_zone = element(var.subnet_config.availability_zones, count.index)

  tags = {
    Name = "app-${count.index}"
  }
}

resource "aws_subnet" "db_subnet" {
  count = length(var.subnet_config.db_subnet_cidr_block)
  vpc_id = var.vpc_id
  cidr_block = var.subnet_config.db_subnet_cidr_block[count.index]
  availability_zone = element(var.subnet_config.availability_zones, count.index)

  tags = {
    Name = "db-${count.index}"
  }
}
