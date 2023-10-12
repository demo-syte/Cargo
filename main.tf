module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "celery-vpc"
  cidr = var.vpc-cidr
  

  azs             = ["ap-southeast-1a", "ap-southeast-1b"] # specify two availability zones
  private_subnets = [var.privatesubnet1, var.privatesubnet2 ]#var.rds-subnet
  public_subnets  = [var.publicsubnet1, var.publicsubnet2]
 

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = false # putting it false due to incured cost of 33$ USD
  single_nat_gateway   = false # Can enable it when needed but keeping it disable for simplicity
  
  tags = {
    Name = "celery-vpc"
  }

  vpc_tags = {
    Name = var.vpc_name
  }
 
}


module "eks" {
  source  = "./modules/eks"
  subnets = module.vpc.subnets
}

#Amazon Elastic Container Registry (ECR)
resource "aws_ecr_repository" "this" {
  name                 = "my-repo"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}
