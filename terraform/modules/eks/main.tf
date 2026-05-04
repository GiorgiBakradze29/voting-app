resource "aws_eks_cluster" "main" {
    name     = "${var.environment}-eks-cluster"
    role_arn = var.eks_cluster_role_arn
    
    vpc_config {
        subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
    }
    
    tags = {
        Name        = "${var.environment}-eks-cluster"
        Environment = var.environment
    }
}

resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.main.name
    node_group_name = "${var.environment}-eks-node-group"
    node_role_arn   = var.eks_node_group_role_arn
    subnet_ids      = var.private_subnet_ids
    instance_types = [ var.node_instance_type ]
    
    scaling_config {
        desired_size = var.node_desired_capacity
        max_size     = var.node_max_capacity
        min_size     = var.node_min_capacity
    }
    
    tags = {
        Name        = "${var.environment}-eks-node-group"
        Environment = var.environment
    }
}