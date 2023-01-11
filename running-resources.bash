#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# Get all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Store the results in an array
results=()

for region in $regions
do
    # List all running instances
    output=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key=='Name'].Value|[0],PrivateIpAddress,PublicIpAddress]" --output text --filters "Name=instance-state-name,Values=running")
    if [ -n "$output" ]; then
        results+=("$output")
    fi
done

# Filter the results by tag name
if [ -n "$1" ]; then
    results=($(echo "${results[@]}" | grep -i "$1"))
fi

# check if the results is empty if yes display None
if [ ${#results[@]} -eq 0 ]; then
    echo "None"
else
    # Display the results in a table format
    echo "${results[@]}" | column -t
fi
