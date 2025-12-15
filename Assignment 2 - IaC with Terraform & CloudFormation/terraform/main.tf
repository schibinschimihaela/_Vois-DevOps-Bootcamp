provider "aws" {
  region = var.region
  profile = "personal"
}

resource "aws_vpc" "cyber" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "cyber-vpc" })
}

resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.cyber.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = false

  tags = merge(var.tags, { Name = "subnet-a" })
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.cyber.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = false

  tags = merge(var.tags, { Name = "subnet-b" })
}

resource "aws_security_group" "mutual_ssh" {
  name        = "mutual-ssh"
  description = "Allow SSH only between Subnet A and Subnet B"
  vpc_id      = aws_vpc.cyber.id

  ingress {
    description = "SSH from Subnet A"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet_a_cidr]
  }

  ingress {
    description = "SSH from Subnet B"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet_b_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "mutual-ssh" })
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "eic_endpoint_sg" {
  name        = "eic-endpoint-sg"
  description = "Security group for EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.cyber.id

  egress {
    description = "Allow SSH to VPC CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, { Name = "eic-endpoint-sg" })
}

resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id          = aws_subnet.a.id
  security_group_ids = [aws_security_group.eic_endpoint_sg.id]

  tags = merge(var.tags, { Name = "eic-endpoint" })
}



resource "aws_instance" "nodea" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.a.id
  vpc_security_group_ids      = [aws_security_group.mutual_ssh.id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  tags = merge(var.tags, { Name = "NodeA" })
}

resource "aws_instance" "nodeb" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.b.id
  vpc_security_group_ids      = [aws_security_group.mutual_ssh.id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  tags = merge(var.tags, { Name = "NodeB" })
}
