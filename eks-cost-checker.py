import boto3
from datetime import datetime, timedelta

# Connect to the Cost Explorer service
ce = boto3.client('ce')

# Get the cost of EKS clusters for the last 30 days
now = datetime.now()
end = now.strftime('%Y-%m-%d')
start = (now - timedelta(days=30)).strftime('%Y-%m-%d')

result = ce.get_cost_and_usage(
    TimePeriod={
        'Start': start,
        'End': end
    },
    Granularity='DAILY',
    Metrics=[
        'BlendedCost'
    ],
    Filter={
        'Dimensions': {
            'Key': 'SERVICE',
            'Values': ['Amazon Elastic Container Service for Kubernetes']
        }
    }
)

# Extract the cost of EKS clusters
total_cost = 0
for time_period in result['ResultsByTime']:
    for group in time_period['Groups']:
        cost = group['Metrics']['BlendedCost']['Amount']
        total_cost += float(cost)

print(f'The total cost of EKS clusters is ${total_cost}')
