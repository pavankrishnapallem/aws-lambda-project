import boto3
from botocore.exceptions import ClientError


def lambda_handler(event, context):

    ec2 = boto3.client("ec2")

    target_name = "dev"
    instance_ids = []

    try:
        response = ec2.describe_instances(
            Filters=[
                {
                    "Name": "instance-state-name",
                    "Values": ["running"]
                }
            ]
        )

        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:

                name = ""

                for tag in instance.get("Tags", []):
                    if tag["Key"] == "Name":
                        name = tag["Value"]
                        break

                if name.startswith(target_name):
                    instance_id = instance["InstanceId"]
                    instance_ids.append(instance_id)

                    print("Found:", name)
                    print("Instance ID:", instance_id)

        # Start all matching instances together
        if instance_ids:
            print("Stopping instances...")

            ec2.stop_instances(
                InstanceIds=instance_ids
            )
        else:
            print("No matching stopped instances found.")

    except ClientError as e:
        print("AWS error:", e)
        raise