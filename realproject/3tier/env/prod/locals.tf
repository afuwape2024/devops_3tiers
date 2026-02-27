locals {
  region                = var.region
  vpc_name              = var.new_vpc
  vpc_cidr              = var.cidr_block
  outside_cidr_block    = var.outside_cidr_block
  web_subnet_cidr_block = var.web_subnet_cidr_block
  app_subnet_cidr_block = var.app_subnet_cidr_block
  db_subnet_cidr_block  = var.db_subnet_cidr_block
  availability_zones    = var.availability_zones
  image_id              = var.image_id
  instance_type         = var.instance_type
  database_rt_name      = "database-rt"

  subnet_config = {
    web_subnet_cidr_block = local.web_subnet_cidr_block
    app_subnet_cidr_block = local.app_subnet_cidr_block
    db_subnet_cidr_block  = local.db_subnet_cidr_block
    availability_zones    = local.availability_zones
  }
}
