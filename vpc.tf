#################################################
# 1 VPC with 2 public subnets, 2 private subnets
# 1 bastion host
# 1 EC2 instance inside private subnets
#################################################

provider "aws" {
  region = "us-east-2"
}

#vpc

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
}

#Subnet

resource "aws_subnet" "subnet_private" {
  count             = length(var.subnet_private)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_private[count.index]
  availability_zone = var.availability_zones[count.index]
}

resource "aws_subnet" "subnet_private_db" {
  count             = length(var.subnet_private_db)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_private_db[count.index]
  availability_zone = var.availability_zones[count.index]
}

resource "aws_subnet" "subnet_public" {
  count                   = length(var.subnet_public)
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet_public[count.index]
  availability_zone       = var.availability_zones[count.index + 1]
}

#route_table

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_public)
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.route_table_public.id
}

#ACL

resource "aws_network_acl" "db" {
  vpc_id = aws_vpc.my_vpc.id
  dynamic "egress" {
    for_each = var.acl_db_egress
    content {
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
      protocol   = egress.value["protocol"]
      cidr_block = egress.value["cidr_block"]
      action     = egress.value["action"]
      rule_no    = egress.value["rule_no"]
    }
  }
  dynamic "ingress" {
    for_each = var.acl_db_ingress
    content {
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
      protocol   = ingress.value["protocol"]
      cidr_block = var.vpc_cidr
      action     = ingress.value["action"]
      rule_no    = ingress.value["rule_no"]
    }
  }
}

resource "aws_network_acl_association" "db" {
  count          = length(var.subnet_private_db)
  subnet_id      = aws_subnet.subnet_private_db[count.index].id
  network_acl_id = aws_network_acl.db.id

}

# endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = var.endpoint_s3
}
