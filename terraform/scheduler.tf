resource "aws_scheduler_schedule" "ec2_start_schedule" {
  name = "ec2-start-schedule"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(15 14 * * ? *)"

  schedule_expression_timezone = "Asia/Kolkata"

  target {
    arn      = aws_lambda_function.ec2_start.arn
    role_arn = aws_iam_role.scheduler_execution_role.arn
  }
}

resource "aws_scheduler_schedule" "ec2_stop_schedule" {
  name = "ec2-stop-schedule"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(30 14 * * ? *)"

  schedule_expression_timezone = "Asia/Kolkata"

  target {
    arn      = aws_lambda_function.ec2_stop.arn
    role_arn = aws_iam_role.scheduler_execution_role.arn
  }
}