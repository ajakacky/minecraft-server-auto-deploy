variable member_ips { sensitive = true }
variable admin_ips  { sensitive = true }


locals {
    deploy = yamldecode(file("userdata.sh"))
}