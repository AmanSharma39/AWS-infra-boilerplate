resource "aws_secretsmanager_secret" "this" {
  name        = "${var.env_name}-${var.name}"
  description = var.description

  tags = {
    Environment = var.env_name
    Name        = "${var.env_name}-${var.name}"
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_data)
}
