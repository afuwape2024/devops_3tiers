variable "region" {
  description = "provision region in US-EAST-2"
}
variable "new_vpc" {
  type = string
  description = "the new vpc"
}
variable "cidr_block" {
  type = string
  description = "the CIDR block for the new VPC"
}
variable "web_subnet_cidr_block" {
  type = list(string)
  description = "the list of CIDR blocks for the web subnets"
}
variable "app_subnet_cidr_block" {
  type = list(string)
  description = "the list of CIDR blocks for the application subnets"
}
variable "db_subnet_cidr_block" {
  type = list(string)
  description = "the list of CIDR blocks for the database subnets"
}
variable "availability_zones" {
  type = list(string)
  description = "the list of availability zones to use for the subnets"
}





