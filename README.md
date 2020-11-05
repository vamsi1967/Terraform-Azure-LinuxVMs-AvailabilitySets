# Terraform-Azure-LinuxVMs-AvailabilitySets
Deploy Azure CentOS Linux VMs with HashiCorp Terraform

## Terraform Main configuration file linuxvm.tf
### Deploy changes using tfvars
In order to configure our variables to be environment agnostic, we will create a tfvars file for each environment in which we want our application to run. Therefore, when running Terraform init, plan, and apply commands we only have to specify the associated tfvars file for the environment in which we would like to run. For example, if we have a development, qa, and production environment we would execute the following command to apply a change in the production environment.
