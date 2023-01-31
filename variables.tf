variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "availability_zones" {
  type = list(string)
}

variable "subnet_private" {
  type = list(string)
}

variable "subnet_private_db" {
  type = list(string)
}

variable "subnet_public" {
  type = list(string)
}

#ACL_subnet
variable "acl_db_egress" {
  type    = map(any)
  default = {}
}

variable "acl_db_ingress" {
  type    = map(any)
  default = {}
}

#SG_private
variable "security_group_egress" {
  type    = map(any)
  default = {}
}

variable "security_group_private_ingress" {
  type    = map(any)
  default = {}
}

variable "security_group_bastion_host_ingress" {
  type    = map(any)
  default = {}
}

#EC2

variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "key_pair" {
  type    = string
  default = ""
}
