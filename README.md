# AWS Bedrock Model Serverless Application

This project demonstrates how to build a serverless AWS application that integrates with AWS Bedrock using a Lambda function and API Gateway. The infrastructure is provisioned with Terraform and deployment is automated using GitHub Actions.


## AWS Architecture


## Prerequisites
- Terraform
- AWS CLI configured with your AWS credentials
- GitHub respository with Actions enabled (optional for CI/CD)
- Local Python virtual environment (recommended)

## How to run the application


## Configuration Requirements

```BEDROCK_MODEL_ID = "bedrock-model-id"```

From the AWS Bedrock Dashboard

```BEDROCK_ENDPOINT = "https://bedrock-runtime.us-east-1.amazonaws.com"```

From Bedrock documentation or AWS console

## Resources
- [Amazon Bedrock endpoints](https://docs.aws.amazon.com/general/latest/gr/bedrock.html) (use Bedrock runtime APIs)