resource "aws_cloudwatch_dashboard" "infra_dashboard" {
  dashboard_name = "infra-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs_service_name],
            ["...", "MemoryUtilization", "ServiceName", var.ecs_service_name]
          ],
          region = var.aws_region, 
          title = "ECS Service Metrics",
          view  = "timeSeries",
          stacked = false
          annotations = {}
        }
      }
    ]
  })
}
