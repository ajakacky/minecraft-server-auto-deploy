variable member_ips {}
variable admin_ips  {}
variable subnet_id  {}
variable vpc_id     {}
variable region     {}

locals {
    deploy = yamldecode(file("deploy.yml"))
}