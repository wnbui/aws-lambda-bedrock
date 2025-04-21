# AWS Bedrock Model Serverless Application

This project demonstrates how to build a serverless AWS application that integrates with AWS Bedrock using a Lambda function and API Gateway. The infrastructure is provisioned with Terraform and deployment is automated using GitHub Actions.


## AWS Architecture
![Architecture](architecture.png)

## Prerequisites

- Terraform
- AWS CLI configured with your AWS credentials (required)
- GitHub respository with Actions enabled (optional for CI/CD)
- Local Python virtual environment (recommended)

## How to run the application

Initial
```zip lambda_function.zip lambda_function.py```
```terraform init```
```terraform validate```
```terraform plan```
```terraform apply```


## Configuration Requirements

Examples:

```BEDROCK_MODEL_ID = "mistral.mistral-small-2402-v1:0"```

From the AWS Bedrock Dashboard

```BEDROCK_ENDPOINT = "https://bedrock-runtime.us-east-1.amazonaws.com"```

From Bedrock documentation or AWS console

## Sample Output
![Sample Output](sample_output.png)

## Resources
- [Amazon Bedrock endpoints](https://docs.aws.amazon.com/general/latest/gr/bedrock.html) (use Bedrock runtime APIs)
- [Inference request parameters and response fields for foundational models](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html)
- [Identity-based policay examples for Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/security_iam_id-based-policy-examples.html)