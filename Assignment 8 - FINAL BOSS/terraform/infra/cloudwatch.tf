
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ip-spectre/backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ip-spectre/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_dashboard" "ip_spectre" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = templatefile(
    "${path.module}/monitoring/cloudwatch-dashboard.json",
    {
      INSTANCE_ID = aws_instance.this.id
      AWS_REGION  = var.aws_region
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "ip-spectre-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.this.id
  }
}