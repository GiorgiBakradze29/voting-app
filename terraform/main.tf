module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  az_count    = 2
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"

  environment  = var.environment
  cluster_name = var.cluster_name
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
}

module "eks" {
  source = "./modules/eks"

  environment             = var.environment
  cluster_name            = var.cluster_name
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_cluster_role_arn    = module.iam.eks_cluster_role
  eks_node_group_role_arn = module.iam.eks_node_group_role
}

module "rds" {
  source = "./modules/rds"

  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  vpc_cidr     = var.vpc_cidr
  db_name      = "votingapp"
  db_username  = var.db_username
  db_password  = var.db_password
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  depends_on = [module.eks]
}