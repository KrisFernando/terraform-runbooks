# modules/iam/github-oidc-role/main.tf
# This module creates an IAM OIDC provider for GitHub and an IAM role
# that GitHub Actions can assume to perform actions in your AWS account.
# This allows for secure, keyless authentication for your CI/CD pipelines.

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role-${var.environment}-${var.github_repository}"

  # Define the trust policy that allows GitHub Actions to assume this role.
  # The 'sub' condition ensures only specific repositories/workflows can assume.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repository}:*"
          }
        }
      },
    ]
  })

  tags = {
    Name        = "${var.environment}-${var.project_name}-github-actions-role"
    Environment = var.environment
    Repository  = "${var.github_organization}/${var.github_repository}"
  }
}

# Attach policies to the IAM role based on the 'policy_statements' variable.
# This allows the role to perform specific actions (e.g., ECR push, S3 access).
resource "aws_iam_role_policy" "github_actions_policy" {
  count = length(var.policy_statements) > 0 ? 1 : 0 # Only create if policy_statements are provided

  name   = "${aws_iam_role.github_actions_role.name}-policy"
  role   = aws_iam_role.github_actions_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = var.policy_statements
  })
}