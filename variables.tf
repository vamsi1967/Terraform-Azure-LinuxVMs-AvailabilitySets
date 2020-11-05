variable "terraform_location" {
    type = string
    description = "location variable declarations of group terraform_rg"
}

variable "terraform_rg" {
    type = string
    description = "name variable declarations for group terraform_rg "
}

variable "terraform_address_space" {
    type = string
    description = "vnet address space, it will assign the subnet on the range"
}

variable "resource_prefix" {
    type = string
    description = "prefix the group attribute to underlying resource"
}

variable "terraform_address_prefix" {
    type = string
    description = "subnet for the vnet"
}

variable "terraform_interface_prefix" {
    type = string
    description = "interface attach to a VM"
}

variable "terraform_environment" {
    type = string
    description = "condition on true for prod, false to dev"
}

variable "terraform_vm_count"{
    type = number
}

variable "terraform_subnets" {
    type = map
    description = "subnet mapping"
}

variable "shelllogin_user" {
    type = string 
    description = "shell username"
} 

variable "shelllogin_pass" {
    type = string
    description = "password for linux servers"
}