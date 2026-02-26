region = "us-east-2"
new_vpc = "new-vpc"
cidr_block = "10.0.0.0/16"
outside_cidr_block ="0.0.0.0/0"
web_subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
app_subnet_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidr_block = ["10.0.5.0/24", "10.0.6.0/24"]
availability_zones = ["us-east-2a", "us-east-2b"]
image_id= "ami-06e3c045d79fd65d9"
instance_type = "t3.micro"


