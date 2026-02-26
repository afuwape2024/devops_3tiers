variable "vpc_id" {
	type = string
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "web_target_group" {
  type    = string
  default = "web-target-group"
}