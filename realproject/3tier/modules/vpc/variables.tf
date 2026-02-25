variable "new_vpc" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "web_subnet_cidr_block" {
  type = list(string)
}
variable "app_subnet_cidr_block" {
  type = list(string)
}
variable "db_subnet_cidr_block" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}   










