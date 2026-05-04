output "eks_node_group_role" {
  value = aws_iam_role.eks_node_group.arn
}

output "eks_cluster_role" {
  value = aws_iam_role.eks_cluster.arn
}