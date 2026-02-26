variable "vpc_id" {
  type = string
}
variable "internet_gateway" {
  type = string
}

variable "web_subnet_ids" {
  type = list(string)
}

