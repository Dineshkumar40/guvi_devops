terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# =========================================================
# UBUNTU 24.04 AMI - US EAST 1
# =========================================================

data "aws_ami" "ubuntu_east" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# =========================================================
# UBUNTU 24.04 AMI - US WEST 2
# =========================================================

data "aws_ami" "ubuntu_west" {

  provider = aws.west

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# =========================================================
# SECURITY GROUP - US EAST 1
# =========================================================

resource "aws_security_group" "east_sg" {

  name        = "nginx-east-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-east-sg"
  }
}


# =========================================================
# SECURITY GROUP - US WEST 2
# =========================================================

resource "aws_security_group" "west_sg" {

  provider = aws.west

  name        = "nginx-west-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-west-sg"
  }
}


# =========================================================
# EC2 INSTANCE - US EAST 1
# =========================================================

resource "aws_instance" "east_server" {

  ami           = data.aws_ami.ubuntu_east.id
  instance_type = "t3.micro"

  security_groups = [
    aws_security_group.east_sg.name
  ]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "Ubuntu-Nginx-East"
  }
}


# =========================================================
# EC2 INSTANCE - US WEST 2
# =========================================================

resource "aws_instance" "west_server" {

  provider = aws.west

  ami           = data.aws_ami.ubuntu_west.id
  instance_type = "t3.micro"

  security_groups = [
    aws_security_group.west_sg.name
  ]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "Ubuntu-Nginx-West"
  }
}


# OUTPUTS
output "east_instance_id" {
  value = aws_instance.east_server.id
}
output "east_public_ip" {
  value = aws_instance.east_server.public_ip
}
output "east_public_dns" {
  value = aws_instance.east_server.public_dns
}
output "west_instance_id" {
  value = aws_instance.west_server.id
}
output "west_public_ip" {
  value = aws_instance.west_server.public_ip
}
output "west_public_dns" {
  value = aws_instance.west_server.public_dns
}
output "east_ami_id" {
  value = data.aws_ami.ubuntu_east.id
}
output "west_ami_id" {
  value = data.aws_ami.ubuntu_west.id
}