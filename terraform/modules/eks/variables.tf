variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "staging-cluster"
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS cluster"
  type        = list(string)
}

variable "eks_node_group_role_arn" {
  description = "ARN of the IAM role for EKS node group"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 2
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
  default     = 3
}

