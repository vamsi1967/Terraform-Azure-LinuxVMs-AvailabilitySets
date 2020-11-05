# this is the backend tfstate remote
# first create a group and storage conatiner to save the file for team reference

terraform {
    backend "azurerm" {
        resource_group_name = "remote-state"
        storage_account_name = "terraformlinuxbackend"
        container_name = "linuxk8svm"
        key = "web-linux.tfstate" # actual file it creates in storage account

    }
}


