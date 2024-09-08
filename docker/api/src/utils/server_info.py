import boto3


def get_server_info():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances()
    return response
