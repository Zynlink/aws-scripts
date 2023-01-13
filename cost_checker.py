import boto3

# Connect to the EC2 service
ec2 = boto3.client('ec2')

# Get a list of all running instances
response = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])

# Get the cost of each instance
total_cost = 0
for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        instance_type = instance['InstanceType']
        region = instance['Placement']['AvailabilityZone'][:-1]
        pricing = boto3.client('pricing', region_name=region)
        price_data = pricing.get_products(
            ServiceCode='AmazonEC2',
            Filters=[
                {'Type': 'TERM_MATCH', 'Field': 'instanceType', 'Value': instance_type},
                {'Type': 'TERM_MATCH', 'Field': 'operatingSystem', 'Value': 'Linux'},
                {'Type': 'TERM_MATCH', 'Field': 'tenancy', 'Value': 'Shared'}
            ]
        )
        price = float(price_data['PriceList'][0]['price']['USD'])
        total_cost += price

print(f'The total cost of running instances is ${total_cost}')
