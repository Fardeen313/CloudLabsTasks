#!/bin/bash

STACK_NAME="my-stack"
TEMPLATE_FILE="env-v01.json"
REGION="us-east-1"

aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file $TEMPLATE_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION