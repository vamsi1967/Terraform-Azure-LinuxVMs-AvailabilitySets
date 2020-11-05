terraform_location = "centralus"
terraform_rg = "linuxvm-k8s"
resource_prefix = "linuxvm"
terraform_address_space = "10.1.0.0/22"
terraform_address_prefix = "10.1.1.0/24"
terraform_interface_prefix = "web"
terraform_environment = "prod"
terraform_vm_count = 3
terraform_subnets = {
    vm_subnet = "10.1.1.0/24"
    AzureBastionSubnet = "10.1.2.0/24" 
}
shelllogin_user = "xploritec"
shelllogin_pass = "Tem01ppassxrw1sd#007"
