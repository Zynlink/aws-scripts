#!/bin/bash

# AWS CLI must be installed and configured with appropriate credentials

# list all running ec2 instances
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]" --output table --filters "Name=instance-state-name,Values=running"

# list all running RDS instances
aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus]" --output table --filters "Name=DBInstanceStatus,Values=available"

# list all running elasticache instances
aws elasticache describe-cache-clusters --query "CacheClusters[*].[CacheClusterId,CacheNodeType,Engine,CacheClusterStatus]" --output table --filters "Name=CacheClusterStatus,Values=available"

# list all running load balancers
aws elbv2 describe-load-balancers --query "LoadBalancers[*].[LoadBalancerName,Type,DNSName,State]" --output table --filters "Name=state,Values=active"

# list all running auto scaling groups
aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[*].[AutoScalingGroupName,MinSize,MaxSize,DesiredCapacity,Status]" --output table --filters "Name=DesiredCapacity,Values=1"
