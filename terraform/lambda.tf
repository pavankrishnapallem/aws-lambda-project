data "archive_file" "ec2_start" {
  type        = "zip"
  source_file = "../lambda/start_script.py"
  output_path = "ec2-start.zip"
}

data "archive_file" "ec2_stop" {
  type        = "zip"
  source_file = "../lambda/stop_script.py"
  output_path = "ec2-stop.zip"
}

resource "aws_lambda_function" "ec2_start" {
  function_name = "ec2-start"

  filename         = data.archive_file.ec2_start.output_path
  source_code_hash = data.archive_file.ec2_start.output_base64sha256

  role = aws_iam_role.lambda_execution_role.arn

  handler = "start_script.lambda_handler"
  runtime = "python3.12"

  timeout = 10
}

resource "aws_lambda_function" "ec2_stop" {
  function_name = "ec2-stop"

  filename         = data.archive_file.ec2_stop.output_path
  source_code_hash = data.archive_file.ec2_stop.output_base64sha256

  role = aws_iam_role.lambda_execution_role.arn

  handler = "stop_script.lambda_handler"
  runtime = "python3.12"

  timeout = 10
}