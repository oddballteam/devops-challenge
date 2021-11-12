output "app_repo_url" {
  value       = module.ecr.repository_url
  description = "Registry URL for app image"
}

output "nginx_repo_url" {
  value       = module.nginx-ecr.repository_url
  description = "Registry URL for Nginx image"
}
