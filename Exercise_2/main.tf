terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "abdus-samad"
  region  = var.region
}

data "archive_file" "app" {
  source_dir  = "${path.module}/code/"
  output_path = "${path.module}/app.zip"
  type        = "zip"
}

resource "aws_lambda_function" "udacity_lambda" {
  filename      = "${path.module}/app.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Test Greeting"
    }
  }
}