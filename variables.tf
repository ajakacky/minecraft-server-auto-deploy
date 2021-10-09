variable member_ips { sensitive = true }
variable admin_ips  { sensitive = true }
variable subnet_id  {}
variable vpc_id     {}

locals {
    deploy = yamldecode(file("userdata.sh"))
}