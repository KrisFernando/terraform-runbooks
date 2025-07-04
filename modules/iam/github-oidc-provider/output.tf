# modules/iam/github-oidc-role/outputs.tf
output "github_provider_arn" {
  description = "The ARN of the Open ID Connect Provider for GitHub."
  value       = aws_iam_openid_connect_provider.github.arn
}
