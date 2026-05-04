variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use for subnets"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

