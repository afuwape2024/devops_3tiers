variable "database_mysql" {
  default = "database_mysql"
}

variable "database_instance_class" {
  default = "db.t3.micro"
}

variable "database_username" {
  default = "dbadmin"
}

variable "database_password" {
  default   = "adminadmin"
  sensitive = true
}

variable "database_security_group" {}

variable "db_subnet" {
  type = list(string)
}