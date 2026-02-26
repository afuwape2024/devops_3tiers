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

variable "web_subnet_cidr_block" {
	type = list(string)
}

variable "app_subnet_cidr_block" {
	type = list(string)
}

variable "db_subnet_cidr_block" {
	type = list(string)
}

variable "outside_cidr_block" {
	type = string
}
