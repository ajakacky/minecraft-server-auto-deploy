# Automated Deployment of Minecraft Servers using Python and Terraform

This repository handles the deployment of EC2 instances for Minecraft Servers

## SSH'ing into the server

`ssh -i YOURPEMFILE.pem ubuntu@PUBLIC_DNS_NAME`

## Viewing userdata logs

You can verify using the following steps:

SSH on launch EC2 instance.
Check the log of your user data script in:
- /var/log/cloud-init.log and
- /var/log/cloud-init-output.log
You can see all logs of your user data script, and it will also create the /etc/cloud folder.

