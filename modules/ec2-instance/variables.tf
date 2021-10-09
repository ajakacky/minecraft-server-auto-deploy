variable tags          { default = {} }
variable ip_addresses  { default = {} }
variable ami_type      { default = "amazon-linux-2" }
variable admin_ips     { default = ["0.0.0.0/0"] }
variable member_ips    { default = ["0.0.0.0/0"] }
variable key_name      {}
variable user_data     {}
variable subnet_id     {}
variable vpc_id        {}
variable name          {}
variable instance_type {}

locals {
    security_group_name = "security-group-${var.name}"
    amis                = {
        amazon-linux-2       = "ami-02e136e904f3da870"
        deep-learning-ubuntu = "ami-0e3c68b57d50caf64"
        ubuntu               = "ami-0747bdcabd34c712a"
    }
}