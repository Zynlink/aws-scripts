#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# Get all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for region in $regions
do
    # List all running instances
    instances=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key=='Name'].Value|[0],PrivateIpAddress,PublicIpAddress]" --output table --filters "Name=instance-state-name,Values=running")
    if [ -n "$instances" ]; then
        echo "Instances running in $region"
        echo "================================="
        echo "$instances"
    fi
done
