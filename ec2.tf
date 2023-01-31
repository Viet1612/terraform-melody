#SG

resource "aws_security_group" "sg_web_private" {
  name        = "allow_privte"
  description = "Allow VPC"
  vpc_id      = aws_vpc.my_vpc.id
  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
  dynamic "ingress" {
    for_each = var.security_group_private_ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ["${var.vpc_cidr}"]
    }
  }

  tags = {
    Name = "allow_privte"
  }
}

resource "aws_security_group" "sg_bastion_host" {
  name        = "sg_bastion_host"
  description = "Allow_public"
  vpc_id      = aws_vpc.my_vpc.id
  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
  dynamic "ingress" {
    for_each = var.security_group_bastion_host_ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = "sg_bastion_host"
  }
}

#ENI

resource "aws_network_interface" "eni_web_private" {
  subnet_id       = aws_subnet.subnet_private[0].id
  security_groups = [aws_security_group.sg_web_private.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "eni_bastion_host" {
  subnet_id       = aws_subnet.subnet_public[0].id
  security_groups = [aws_security_group.sg_bastion_host.id]

  tags = {
    Name = "primary_network_interface_pub"
  }
}

#EC2

resource "aws_instance" "web_private" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "vietkey"

  network_interface {
    network_interface_id = aws_network_interface.eni_web_private.id
    device_index         = 0
  }
  tags = {
    Name = "web_private"
  }

}

resource "aws_instance" "bastion_host" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "vietkey"

  network_interface {
    network_interface_id = aws_network_interface.eni_bastion_host.id
    device_index         = 0
  }
  tags = {
    Name = "bastion_host"
  }
  #test thu remote exec
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install httpd -y",
  #     "sudo systemctl restart httpd",
  #     "sudo systemctl enable httpd"
  #   ]
  # }
  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip
  #   user        = "ec2-user"
  #   private_key = file("./key_ssh/vietkey.pem")
  #   timeout     = "4m"
  # }

}
