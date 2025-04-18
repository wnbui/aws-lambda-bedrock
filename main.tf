terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

### IAM Roles and Policies

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "bedrock_model_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# Attach Basic Execution Role
resource "aws_iam_policy_attachment" "lambda_basic_attachment" {
  name       = "lambda_basic_policy_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom Bedrock Policy
resource "aws_iam_policy" "bedrock_policy" {
  name = "bedrock_test_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["bedrock:InvokeModel"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attach Custom Bedrock Policy
resource "aws_iam_policy_attachment" "bedrock_policy_attachment" {
  name       = "bedrock_policy_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = aws_iam_policy.bedrock_policy
}

### Lambda Function
resource "aws_lambda_function" "bedrock_model_lambda" {
  filename      = "lambda_function.zip"
  runtime       = "python3.12"
  function_name = "bedrock_model_function"
  role          = aws_iam_role.lambda_exec_role
  handler       = "lambda_function.handler"

  source_code_hash = filebase64sha256("lambda_function.zip")

  # Update these variables based on model and endpoint
  environment {
    variables = {
      # From the AWS Bedrock Dashboard
      BEDROCK_MODEL_ID = "bedrock-model-id"
      # From Bedrock documentation or AWS console
      BEDROCK_ENDPOINT = "https://bedrock-runtime.us-east-1.amazonaws.com"
    }
  }

  memory_size = 256
  timeout     = 30
}

### API Gateway Configuration

# Rest API
resource "aws_api_gateway_rest_api" "bedrock_model_api" {
  name        = "bedrock_model_api"
  description = "API Gateway for Bedrock model application"
}

# API Endpoint
resource "aws_api_gateway_resource" "bedrock_model_resource" {
  rest_api_id = aws_api_gateway_rest_api.bedrock_model_api.id
  parent_id   = aws_api_gateway_rest_api.bedrock_model_api.root_resource_id
  path_part   = "bedrock-model"
}

# POST method
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.bedrock_model_api.id
  resource_id   = aws_api_gateway_resource.bedrock_model_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrate API Gateway with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bedrock_model_api.id
  resource_id             = aws_api_gateway_resource.bedrock_model_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bedrock_model_lambda.invoke_arn
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bedrock_model_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bedrock_model_api.execution_arn}/*/*"
}

# API Deployment
resource "aws_api_gateway_deployment" "bedrock_model_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.bedrock_model_api.id
  description = "Deployment for Bedrock Model API"
}

# Stage resource
resource "aws_api_gateway_stage" "prod_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.bedrock_model_api.id
  deployment_id = aws_api_gateway_deployment.bedrock_model_deployment.id
  variables     = {}
}
