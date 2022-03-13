{
    "Version": "2012-10-17",
	"Statement": [
        {
            "Effect": "Allow",
            "Actions": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
            ],
            "Resources": [
                "arn:aws:logs:*:*:*"
            ]
        },
        {
            "Sid": "StartStopInstance",
            "Effect": "Allow",
            "Actions": [
                "ec2:Describe*",
                "ec2:Start*",
                "ec2:Stop*"
            ]
            "Resources": [
                "*"
            ]
        }
    ]
}