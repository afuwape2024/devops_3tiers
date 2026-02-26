variable "vpc_id" {
	type = string
}

variable "web_template" {
  default = "app-launch-template"
}

variable "image_id" {
  type = string
  description = "the image was selected from us-east-2 region"
}

variable "instance_type" {
  type = string 
}

variable "web_security_group" {
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

variable "app_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 3
}

variable "desired_capacity" {
  default = 1
}