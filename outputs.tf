output "api_invoke_url" {
  description = "The URL to invoke the Bedrock Model API"
  value       = "https://${aws_api_gateway_rest_api.bedrock_model_api.id}.execute-api.us-east-1.amazonaws.com/prod/bedrock-model"
}
