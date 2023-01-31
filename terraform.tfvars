vpc_cidr = "10.0.0.0/16"

subnet_private = ["10.0.0.0/24", "10.0.1.0/24"]

subnet_private_db = ["10.0.4.0/24", "10.0.5.0/24"]

subnet_public = ["10.0.2.0/24", "10.0.3.0/24"]

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

#ACl

acl_db_egress = {
  acl_db_engress_001 = {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

acl_db_ingress = {
  acl_db_ingress_001 = {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3306
    to_port    = 3306
  }
}

#SG_web

security_group_egress = {
  security_group_private__001 = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
  }
}

security_group_private_ingress = {
  security_group_private_ingress_001 = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["xx.xx.x.x/x"]
    description = "demo-ingress-1"
  }
    security_group_private_ingress_002 = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["xx.xx.x.x/x"]
    description = "demo-ingress-1"
  }
}

security_group_bastion_host_ingress = {
  security_group_bastion_host_ingress_001 = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "demo-bastion_host_ingress-1"
  }
}


#enpoint

endpoint_s3 = "com.amazonaws.us-east-2.s3"

#ec2
ami           = "ami-05bfbece1ed5beb54"
instance_type = "t2.micro"
key_pair = "vietkey"

#s3
s3_name = "terraform-melody1612"