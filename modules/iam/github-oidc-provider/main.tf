# modules/iam/github-oidc-provider/main.tf
# This module creates an IAM OIDC provider for GitHub and an IAM role
# that GitHub Actions can assume to perform actions in your AWS account.
# This allows for secure, keyless authentication for your CI/CD pipelines.

# Create the IAM OIDC provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # Current GitHub OIDC thumbprint.
  # Note: Thumbprints can change. It's good practice to verify the latest from
  # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780fa86"]

  tags = {
    Name        = "github-oidc-provider-${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}