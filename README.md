# Terraform-Azure-LinuxVMs-AvailabilitySets
Deploy Azure CentOS Linux VMs with HashiCorp Terraform

### Terraform Main configuration file linuxvm.tf
### Terraform input variables
When constructing your cloud architecture using Terraform, you can dynamically configure your resources and services using input variables. You must define input variables in a .tf file. Typically we define our input variables in a “variables.tf” file. Within our file we define variable names, types, default values, and descriptions. Below is an example of what our “variables.tf” looks like.

variable "environment" {
 type = "string"
 description = "Environment in which to deploy application"
 }
 
### Deploy changes using tfvars
In order to configure our variables to be environment agnostic, we will create a tfvars file for each environment in which we want our application to run. Therefore, when running Terraform init, plan, and apply commands we only have to specify the associated tfvars file for the environment in which we would like to run. For example, if we have a development, qa, and production environment we would execute the following command to apply a change in the production environment.
## Steps to apply
$ terraform init
$ terraform plan -out linuxapply.plan
$ terraform apply linuxapply.plan --auto-approve
