output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "db_name" {
  value = module.rds.db_name
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  value = module.eks.eks_cluster_certificate_authority
}

output "vote_ecr_url" {
  value = module.ecr.vote_ecr_url
}

output "result_ecr_url" {
  value = module.ecr.result_ecr_url
}   

output "worker_ecr_url" {
  value = module.ecr.worker_ecr_url
}