import boto3


def get_server_info(instance_id: str):
    ec2 = boto3.client('ec2')
    try:
        response = ec2.describe_instances(InstanceIds=[instance_id])
        return True if response['Reservations'][0]['Instances'][0]['State']['Name'] == 'running' else False
    except Exception as e:
        raise e


def get_all_ec2_instance_ids():
    # Create an EC2 client
    ec2 = boto3.client('ec2')

    try:
        # Get all instances
        response = ec2.describe_instances()

        # Extract instance IDs
        instance_ids = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                
                if instance['State']['Name'] != 'terminated':
                    instance_ids.append({
                        "id": instance['InstanceId'],
                        "name": instance['Tags'][0]['Value']
                    })

        return instance_ids
    except Exception as e:
        return f"Error: {str(e)}"
