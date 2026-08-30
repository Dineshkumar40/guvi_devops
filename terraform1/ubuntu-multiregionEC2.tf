terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


# Provider - us-east-1
provider "aws" {
  region = "us-east-1"
}

# Provider - us-west-2

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}


# Ubuntu 24.04 AMI - us-east-1
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


# Ubuntu 24.04 AMI - us-west-2
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


# EC2 - us-east-1
resource "aws_instance" "east_server" {

  ami           = data.aws_ami.ubuntu_east.id
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu-24-East"
  }
}


# EC2 - us-west-2
resource "aws_instance" "west_server" {

  provider = aws.west

  ami           = data.aws_ami.ubuntu_west.id
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu-24-West"
  }
}

# Outputs Block
output "east_ami_id" {
  value = data.aws_ami.ubuntu_east.id
}

output "west_ami_id" {
  value = data.aws_ami.ubuntu_west.id
}

output "east_instance_id" {
  value = aws_instance.east_server.id
}

output "west_instance_id" {
  value = aws_instance.west_server.id
}

output "east_public_ip" {
  value = aws_instance.east_server.public_ip
}

output "west_public_ip" {
  value = aws_instance.west_server.public_ip
}