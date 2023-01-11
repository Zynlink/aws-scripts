#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# get all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for region in $regions
do
    echo "Checking resources in region: $region"
    echo "======================="

    # list all running ec2 instances
    ec2_output=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]" --output text --filters "Name=instance-state-name,Values=running")
    if [ -z "$ec2_output" ]; then
        echo "None"
    else
        echo "$ec2_output" | column -t
    fi

    # list all running RDS instances
    rds_output=$(aws rds describe-db-instances --region $region --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus]" --output text --filters "Name=DBInstanceStatus,Values=available")
    if [ -z "$rds_output" ]; then
        echo "None"
    else
        echo "$rds_output" | column -t
    fi

    # list all running elasticache instances
    elasticache_output=$(aws elasticache describe-cache-clusters --region $region --query "CacheClusters[*].[CacheClusterId,CacheNodeType,Engine,CacheClusterStatus]" --output text --filters "Name=CacheClusterStatus,Values=available")
    if [ -z "$elasticache_output" ]; then
        echo "None"
    else
        echo "$elasticache_output" | column -t
    fi

    # list all running load balancers
    elb_output=$(aws elbv2 describe-load-balancers --region $region --query "LoadBalancers[*].[LoadBalancerName,Type,DNSName,State]" --output text --filters "Name=state,Values=active")
    if [ -z "$elb_output" ]; then
        echo "None"
    else
        echo "$elb_output" | column -t
    fi

    # list all auto-scaling groups that have at least one instance in service
    asg_output=$(aws autoscaling describe-auto-scaling-groups --region $region --query "AutoScalingGroups[*].[AutoScalingGroupName,MinSize,MaxSize,DesiredCapacity,Status]" --output text --filters "Name=LifecycleState,Values=InService")
    if [ -z "$asg_output" ]; then
        echo "None"
    else
        echo "$asg_output" | column -t
    fi
    echo 
done
