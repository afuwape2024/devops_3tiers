module "vpc" {
  source = "../../modules/vpc-module"
  new_vpc = var.new_vpc
  cidr_block = var.cidr_block
}

module "subnet" {
  source = "../../modules/subnet-module"
  vpc_id = module.vpc.new_vpc
  subnet_config = local.subnet_config
}

module "internet_gateway" {
  source = "../../modules/igw-module"
  vpc_id = module.vpc.new_vpc
}

module "nat_and_app_rtb" {
  source = "../../modules/nat-gw-module"
  vpc_id = module.vpc.new_vpc
  web_subnet_ids = module.subnet.web_subnet
  app_subnet_ids = module.subnet.app_subnet
  db_subnet_ids = module.subnet.db_subnet
  database_rt = "database-rt"
}

module "route_table" {
  source = "../../modules/routetable-module"
  vpc_id             = module.vpc.new_vpc
  internet_gateway   = module.internet_gateway.internet_gateway
  web_subnet_ids     = module.subnet.web_subnet
}

module "network_acl" {
  source = "../../modules/nacl-module"
  vpc_id = module.vpc.new_vpc
  web_subnet_ids = module.subnet.web_subnet
  app_subnet_ids = module.subnet.app_subnet
  db_subnet_ids = module.subnet.db_subnet
  web_subnet_cidr_block = var.web_subnet_cidr_block
  app_subnet_cidr_block = var.app_subnet_cidr_block
  db_subnet_cidr_block = var.db_subnet_cidr_block
  outside_cidr_block = var.outside_cidr_block
}

module "security_group" {
  source = "../../modules/security-group-module"
  vpc_id = module.vpc.new_vpc
}

module "load_balancer" {
  source = "../../modules/app-alb-module"
  vpc_id         = module.vpc.new_vpc
  web_subnet_ids = module.subnet.web_subnet
}

module "autoscaling" {
  source = "../../modules/app-asg-module"
  vpc_id                = module.vpc.new_vpc
  image_id              = var.image_id
  instance_type         = var.instance_type
  web_security_group    = module.security_group["web-security_group"]
  web_subnet_ids        = module.subnet.web_subnet
  app_subnet_ids        = module.subnet.app_subnet
  db_subnet_ids         = module.subnet.db_subnet
  web_subnet_cidr_block = var.web_subnet_cidr_block
  app_sg_id             = module.security_group.app_security_group
  private_subnet_ids    = module.subnet.app_subnet
  target_group_arn      = module.load_balancer.web_target_group
}

module "database_mysql" {
  source = "../../modules/rds-module"
  database_security_group = module.security_group.database_security_group
  db_subnet               = module.subnet.db_subnet
}

