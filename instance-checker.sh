#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# Get all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Create the table header
echo "InstanceId | InstanceType | State | Name | PrivateIpAddress | PublicIpAddress | Region"

for region in $regions
do
    # List all running instances
    instances=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key=='Name'].Value|[0],PrivateIpAddress,PublicIpAddress]" --output text --filters "Name=instance-state-name,Values=running")

    # Loop through the instances and add them to the table
    while read -r line; do
        # Extract the details for each instance
        instanceId=$(echo $line | awk '{print $1}')
        instanceType=$(echo $line | awk '{print $2}')
        state=$(echo $line | awk '{print $3}')
        name=$(echo $line | awk '{print $4}')
        privateIp=$(echo $line | awk '{print $5}')
        publicIp=$(echo $line | awk '{print $6}')

        # Add the instance to the table
        echo "$instanceId | $instanceType | $state | $name | $privateIp | $publicIp | $region"
    done <<< "$instances"
done
