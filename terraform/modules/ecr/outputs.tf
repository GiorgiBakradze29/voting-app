output "vote_ecr_url" {
  value = aws_ecr_repository.vote.repository_url
}

output "result_ecr_url" {
  value = aws_ecr_repository.result.repository_url
}   

output "worker_ecr_url" {
  value = aws_ecr_repository.worker.repository_url
}