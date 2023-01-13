import boto3
from datetime import datetime, timedelta

# Connect to the Cost Explorer service
ce = boto3.client('ce')

# Get the cost of running instances for the last 30 days
now = datetime.now()
end = now.strftime('%Y-%m-%d')
start = (now - timedelta(days=30)).strftime('%Y-%m-%d')

result = ce.get_reservation_utilization(
    TimePeriod={
        'Start': start,
        'End': end
    },
    GroupBy=[
        {
            'Type': 'DIMENSION',
            'Key': 'SUBSCRIPTION_ID'
        },
    ]
)

# Extract the cost of running instances
total_cost = 0
for group in result['UtilizationsByTime'][0]['Groups']:
    cost = group['Total']['UnblendedCost']['Amount']
    total_cost += float(cost)

print(f'The total cost of running instances is ${total_cost}')
