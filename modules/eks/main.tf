module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "celery-cluster"
  cluster_version = "1.20"
  subnets         = var.subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_type = "m5.large"
      key_name      = var.key_name
    }
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group" {
  value = module.eks.cluster_security_group
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}
