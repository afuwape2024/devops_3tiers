locals {
  subnet_config = {
    web_subnet_cidr_block = var.web_subnet_cidr_block
    app_subnet_cidr_block = var.app_subnet_cidr_block
    db_subnet_cidr_block  = var.db_subnet_cidr_block
    availability_zones    = var.availability_zones
  }
}

locals {
  vpc_cidr        = var.cidr_block
  web_cidr         = var.web_subnet_cidr_block
  app_cidr         = var.app_subnet_cidr_block
  database_cidr    = var.db_subnet_cidr_block
}
