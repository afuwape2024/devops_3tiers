variable "vpc_id" {
  type = string
}

variable "subnet_config" {
  type = object({
    web_subnet_cidr_block = list(string)
    app_subnet_cidr_block = list(string)
    db_subnet_cidr_block  = list(string)
    availability_zones    = list(string)
  })
}