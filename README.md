### Project Description: AWS Cloud Resume API

#### Overview
The AWS Lambda Resume API project aimed to create and deploy a serverless API capable of serving resume data stored in DynamoDB. The infrastructure was defined using Terraform, and the deployment process was automated with GitHub Actions. The project involved setting up an API Gateway, a Lambda function, DynamoDB table, and IAM roles and policies to ensure secure and efficient operation.

#### Architecture Breakdown

1. **Client**:
   - **Tools**: HTTP client.
   - **Function**: Sends HTTP requests to the API Gateway to fetch resume data.

2. **API Gateway**:
   - **Resource**: `aws_apigatewayv2_api`, `aws_apigatewayv2_stage`, `aws_apigatewayv2_integration`, `aws_apigatewayv2_route`
   - **Function**: Routes the requests to the appropriate Lambda function.

3. **Lambda Function**:
   - **Resource**: `aws_lambda_function`
   - **Function**: Executes code to fetch data from DynamoDB and return it as JSON.

4. **DynamoDB**:
   - **Resource**: `aws_dynamodb_table`, `aws_dynamodb_table_item`
   - **Function**: Stores resume data and allows retrieval based on user_id.

5. **IAM Role**:
   - **Resource**: `aws_iam_role`, `aws_iam_policy`, `aws_iam_role_policy_attachment`
   - **Function**: Grants necessary permissions to the Lambda function to access DynamoDB,log data and to be invoked by API Gateway.

6. **GitHub Actions**:
   - **Configuration**: `.github/workflows/deploy.yml`
   - **Function**: Automates the deployment process of the Lambda function whenever changes are pushed to the repository.

#### Terraform Scripts and Structure

- **api_gateway.tf**: Defines the API Gateway resources, integration with Lambda, and permissions.
- **dynamodb.tf**: Sets up the DynamoDB table and inserts initial data.
- **iam.tf**: Configures IAM roles and policies for Lambda.
- **lambda.tf**: Defines the Lambda function, specifying the S3 bucket and key for the deployment package.
- **output.tf**: Outputs the API Gateway endpoint URL.
- **provider.tf**: Configures Terraform and AWS provider settings.

#### Lambda Code

The Lambda function written in Python retrieves resume data from DynamoDB based on a hardcoded user_id ('thelma_laryea') and returns it in JSON format. It includes logging and error handling to ensure robust operation.

PS: I faced some issues with my initial code hence had to hardcode the id because of the time limit.

#### GitHub Actions Workflow

- **Steps**:
  1. **Checkout Repository**: Uses `actions/checkout` to clone the repository.
  2. **Zip Lambda Code**: Zips the Lambda function code.
  3. **Upload to S3**: Uploads the zipped code to an S3 bucket.
  4. **Deploy Lambda Function**: Updates the Lambda function code from the S3 bucket.




