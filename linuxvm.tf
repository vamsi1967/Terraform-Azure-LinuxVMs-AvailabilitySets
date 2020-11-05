provider "azurerm" {  
   version = "2.29.0"
   features {} 
}

resource "azurerm_resource_group" "terraform_rg" {
   name     = var.terraform_rg
   location = var.terraform_location  
}

# just added 2nd group nothing to do this with main
#resource "azurerm_resource_group" "tf_rg" {
#  name = var.terraform_rg
#   location = "centralus"
#}

resource "azurerm_virtual_network" "terraform_vnet" {
   name = "${var.resource_prefix}-vnet"
   location = var.terraform_location
   address_space = [var.terraform_address_space]
   resource_group_name = azurerm_resource_group.terraform_rg.name
}

#resource "azurerm_subnet" "terraform_subnet"{
#   name = "${var.resource_prefix}-subnet"
#   resource_group_name = azurerm_resource_group.terraform_rg.name
##   address_prefixes = [var.terraform_address_prefix]
 #  virtual_network_name = azurerm_virtual_network.terraform_vnet.name

#} # this is useful when single subnet created when multiple, use for_each

resource "azurerm_subnet" "terraform_subnet" {
   for_each = var.terraform_subnets

   name = each.key
   #location = var.terraform_location
   resource_group_name = azurerm_resource_group.terraform_rg.name
   virtual_network_name = azurerm_virtual_network.terraform_vnet.name
   address_prefixes = [each.value]
   
}

resource "azurerm_network_interface" "terraform_netint" {
   name = "${var.terraform_interface_prefix}-${format("%02d",count.index)}-nic"
   resource_group_name = azurerm_resource_group.terraform_rg.name
   location = var.terraform_location
   count = var.terraform_vm_count

   ip_configuration {
      name = "${var.terraform_interface_prefix}-ip"
      subnet_id = azurerm_subnet.terraform_subnet["vm_subnet"].id
      private_ip_address_allocation = "dynamic" 
      #public_ip_address_id = azurerm_public_ip.terraform_web_publicip.id
      public_ip_address_id = count.index == 0 ? azurerm_public_ip.terraform_web_publicip.id : null
      
   }
}

resource "azurerm_public_ip" "terraform_web_publicip" {
   name = "${var.terraform_interface_prefix}-public-ip"
   location = var.terraform_location
   resource_group_name = azurerm_resource_group.terraform_rg.name
   allocation_method = var.terraform_environment == "prod" ? "Dynamic" : "static"
}

resource "azurerm_network_security_group" "terraform_nsg"{
   name = "${var.resource_prefix}-nsg"
   resource_group_name = azurerm_resource_group.terraform_rg.name  
   location = var.terraform_location
}

resource "azurerm_network_security_rule" "terraform_inbound_rule"{
   name = "ssh"
   direction = "Inbound"
   priority = "100"
   protocol = "Tcp"
   access = "Allow"
   source_address_prefix = "*"
   destination_address_prefix = "*"
   source_port_range = "*"
   destination_port_range = "22" 
   resource_group_name = azurerm_resource_group.terraform_rg.name
   network_security_group_name = azurerm_network_security_group.terraform_nsg.name
}
#resource "azurerm_network_interface_security_group_association" "web-01-nsg_association"{
#   network_security_group_id = azurerm_network_security_group.terraform_nsg.id
#   network_interface_id = azurerm_network_interface.terraform_netint.id 
#} # single nic association, if there are multiple we use subnet level nsg associations as below

resource "azurerm_subnet_network_security_group_association" "web-server-nsg_association"{
   network_security_group_id = azurerm_network_security_group.terraform_nsg.id
   subnet_id = azurerm_subnet.terraform_subnet["vm_subnet"].id 
}

resource "azurerm_linux_virtual_machine" "terraform_linux_vm"{
   resource_group_name = azurerm_resource_group.terraform_rg.name
   name = "${var.terraform_interface_prefix}-${format("%02d",count.index)}"
   disable_password_authentication = false
   admin_password = var.shelllogin_pass
   admin_username = var.shelllogin_user
   #availability_set_id = azurerm_availability_set.terraform_avail_set.id 
   network_interface_ids = [azurerm_network_interface.terraform_netint[count.index].id]
   count = var.terraform_vm_count
   location = var.terraform_location
   size= "Standard_B2s"
 os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
 }
 source_image_reference {
    publisher = "OpenLogic"
    offer = "CentOs"
    sku = "7.5"
    version = "latest"
 }

}

# resource "azurerm_availability_set" "terraform_avail_set"{
#    location = var.terraform_location
#    resource_group_name = azurerm_resource_group.terraform_rg.name
#    name = "${var.resource_prefix}-availset"
#    managed = true
#    platform_fault_domain_count = 2
# }

 
