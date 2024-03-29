# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Deployment5.1-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Terraform = "true"
  }
}

module "ssh_security_group" {
  name        = "ssh"
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 5.0"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Terraform = "true"
    Name= "Deployment5.1-ssh-sg-group"
  }

}

module "http_8080_security_group" {
  name        = "jenkins-server"
  source  = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version = "~> 5.0"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Terraform = "true"
    Name= "Deployment5.1-8080-sg-group"
  }

}

module "app_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "app-service"
  description = "Security group for application with custom port 8000 open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      description = " Gunicorn Application port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      description = "All protocols"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "aws_instance" "web_server01" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [module.ssh_security_group.security_group_id, module.http_8080_security_group.security_group_id,module.app_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name = "pub-instance"
  #depends_on = [aws_internet_gateway.gw]

  user_data = file("user_data.sh")

  tags = {
    Name = "deployment5.1-jenkinsServer"
  }

}

resource "aws_instance" "application_server01" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [module.ssh_security_group.security_group_id,module.app_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name = "pub-instance"
  #depends_on = [aws_internet_gateway.gw]

  user_data = file("app_install.sh")

  tags = {
    Name = "deployment5.1-applicationServer1"
  }

}

resource "aws_instance" "application_server02" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [module.ssh_security_group.security_group_id,module.app_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  key_name = "pub-instance"
  #depends_on = [aws_internet_gateway.gw]

  user_data = file("app_install.sh")

  tags = {
    Name = "deployment5.1-applicationServer2"
  }

}