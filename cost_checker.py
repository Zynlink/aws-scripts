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
        instance_data = ec2.describe_instance_types(InstanceTypes=[instance_type])
        hourly_rate = instance_data['InstanceTypes'][0]['Price']['USD']
        total_cost += hourly_rate

print(f'The total cost of running instances is ${total_cost}')
