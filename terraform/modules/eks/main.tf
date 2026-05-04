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

data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "ebs_csi_driver" {
  name = "${var.environment}-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  depends_on = [
    aws_eks_node_group.main,
    aws_iam_role_policy_attachment.ebs_csi_driver
  ]
}