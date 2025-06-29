resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/app"
  retention_in_days = 14
}
