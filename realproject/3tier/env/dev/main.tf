module "new_vpc" {
  source = "../../modules/vpc"
  new_vpc = var.new_vpc
  cidr_block = var.cidr_block
  web_subnet_cidr_block = var.web_subnet_cidr_block
  app_subnet_cidr_block = var.app_subnet_cidr_block
  db_subnet_cidr_block = var.db_subnet_cidr_block
  availability_zones = var.availability_zones
}
