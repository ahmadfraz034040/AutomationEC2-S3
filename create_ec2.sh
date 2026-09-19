#!/bin/bash

AMI_ID="ami-0c02fb55956c7d316"
INSTANCE_TYPE="t2.micro"
KEY_NAME="miseacademy"
SECURITY_GROUP="ec2-s3-access-sg"
INSTANCE_NAME="EC2WithS3Access2"
VPC_ID="vpc-0f9febdaf7058a6a6"

# Get subnet
SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "Subnets[0].SubnetId" \
    --output text)

if [ "$SUBNET_ID" = "None" ] || [ -z "$SUBNET_ID" ]; then
    echo "❌ No subnet found in VPC: $VPC_ID"
    exit 1
fi

echo "✅ Using Subnet: $SUBNET_ID"

# Get Security Group ID
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SECURITY_GROUP" \
    --query "SecurityGroups[0].GroupId" \
    --output text)

if [ "$SECURITY_GROUP_ID" = "None" ] || [ -z "$SECURITY_GROUP_ID" ]; then
    echo "❌ Security group not found: $SECURITY_GROUP"
    exit 1
fi

echo "✅ Using Security Group: $SECURITY_GROUP_ID"

# Launch EC2
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --subnet-id "$SUBNET_ID" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query "Instances[0].InstanceId" \
    --output text)

if [ $? -eq 0 ]; then
    echo "✅ EC2 Instance Launched Successfully!"
    echo "📌 Name: $INSTANCE_NAME"
    echo "🆔 Instance ID: $INSTANCE_ID"
else
    echo "❌ Failed to launch EC2 instance."
    exit 1
fi