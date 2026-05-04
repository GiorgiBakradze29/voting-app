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
