import json
import boto3
import os
import logging
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB client outside of the handler for better performance
dynamodb = boto3.client('dynamodb', region_name=os.environ.get('AWS_REGION', 'us-east-1'))

def lambda_handler(event, context):
    # Hard-code the user_id to 'thelma_laryea'
    table_name = os.environ.get('DYNAMODB_TABLE', 'ResumeTable')
    user_id = 'thelma_laryea'
    
    # Add context to logs
    request_id = context.aws_request_id
    function_name = context.function_name
    logger.info(f"Request ID: {request_id}, Function: {function_name}, Fetching data for user_id: {user_id}")

    try:
        # Fetch the item from DynamoDB
        response = dynamodb.get_item(
            TableName=table_name,
            Key={
                'user_id': {'S': user_id}
            }
        )
        
        # Check if item was found
        item = response.get('Item')
        if item:
            logger.info(f"Successfully fetched item for user_id: {user_id}")
            return {
                'statusCode': 200,
                'body': json.dumps(item),
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                }
            }
        else:
            logger.warning(f"Item not found for user_id: {user_id}")
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Item not found'}),
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                }
            }

    except ClientError as e:
        # Log the error with traceback
        logger.error(f"Error fetching data from DynamoDB for user_id: {user_id}. Exception: {e}", exc_info=True)

        # Handle DynamoDB errors
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error fetching data from DynamoDB', 'error': str(e)}),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
