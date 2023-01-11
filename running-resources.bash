#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# get all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

ec2_results=()
rds_results=()
elasticache_results=()
elb_results=()
asg_results=()

for region in $regions
do
    echo "Checking resources in region: $region"
    echo "======================="

    # list all running ec2 instances
    ec2_output=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]" --output text --filters "Name=instance-state-name,Values=running")
    if [ -z "$ec2_output" ]; then
        ec2_results+=("None")
    else
        ec2_results+=("$ec2_output")
    fi

    # list all running RDS instances
    rds_output=$(aws rds describe-db-instances --region $region --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus]" --output text --filters "Name=DBInstanceStatus,Values=available")
    if [ -z "$rds_output" ]; then
        rds_results+=("None")
    else
        rds_results+=("$rds_output")
    fi

    # list all running elasticache instances
    elasticache_output=$(aws elasticache describe-cache-clusters --region $region --query "CacheClusters[*].[CacheClusterId,Cache
