variable "vpc_id" {
  type = string
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "app_rt" {
  type    = list(string)
  default = ["app_rt", "app_rt1"]
}

variable "database_rt" {
  type    = string
}