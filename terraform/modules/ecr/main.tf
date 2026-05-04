resource "aws_ecr_repository" "vote" {
  name = "voting-app-vote"
  image_tag_mutability = "MUTABLE"

    tags = {
        Name        = "${var.environment}-vote-repo"
        Environment = var.environment
    }
}

resource "aws_ecr_repository" "result" {
  name = "voting-app-result"
  image_tag_mutability = "MUTABLE"

    tags = {
        Name        = "${var.environment}-result-repo"
        Environment = var.environment
    }
}

resource "aws_ecr_repository" "worker" {
    name = "voting-app-worker"
    image_tag_mutability = "MUTABLE"   

    tags = {
        Name        = "${var.environment}-worker-repo"
        Environment = var.environment
    } 
}