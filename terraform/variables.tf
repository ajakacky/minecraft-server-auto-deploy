variable member_ips {}
variable admin_ips  {}
variable subnet_id  {}
variable vpc_id     {}
variable region     {}
variable cf_api_key { sensitive=true }

locals {
    deploy = yamldecode(file("deploy.yml"))
}