provider "aws" {
  region = "eu-central-1"
}

/*
resource "aws_instance" "myInstance" {
  ami                    = "ami-03c3a7e4263fd998c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "testing"
  root_block_device {
    volume_size           = "70"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  user_data = file("httpd-setup.sh")
}
# data disk
ebs_block_device {
  device_name           = "/dev/xvda"
  volume_size           = "10"
  volume_type           = "gp2"
  delete_on_termination = true
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

ebs_block_device {
  device_name           = "/dev/xvda"
  volume_size           = "10"
  volume_type           = "gp2"
  delete_on_termination = true
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}
*/


# Create EC2 Instance
resource "aws_instance" "myInstance" {
  ami                    = "ami-0e1ce3e0deb8896d2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "testing"
  # root disk
  root_block_device {
    volume_size           = "22"
    volume_type           = "gp2"
    delete_on_termination = true
  }



  user_data = file("httpd-setup.sh")
  tags = {
    Name        = "Lark-test"
    Environment = "dev"
  }
}


resource "aws_ebs_volume" "example" {
  availability_zone = "eu-central-1c"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
}



resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.sg_ingress_rules)

  type              = "ingress"
  from_port         = var.sg_ingress_rules[count.index].from_port
  to_port           = var.sg_ingress_rules[count.index].to_port
  protocol          = var.sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.sg_ingress_rules[count.index].cidr_block]
  description       = var.sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.instance.id
}

variable "sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
    {
      from_port   = 440
      to_port     = 440
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "test"
    },
  ]
}





output "DNS" {
  value = aws_instance.myInstance.public_dns
}
