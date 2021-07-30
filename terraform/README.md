# Terraform configuration for Project 3
- You should have a working service connection or some kind of service principal set up whether 
it is your own Azure subscription or a service connection created by a trainer.
## Modules

### What is a module?
- Modules are the main way to package and reuse resource configurations with Terraform.
- The top level of the terraform directory is the main `azurerm` module with two submodules: 
  - `kubernetes`
  - `azuredevops`

### AzureRM
- Main module, used to create AzureRM resource groups, clusters, and container registry.
- This is the `main.tf` at the root of the terraform directory.

### Kubernetes
- Module used to configure Kubernetes namespaces and resource quotas.

### AzureDevops
- Module used to create service connections for ACR.
- Creates kubernetes service connections for pipelines.
- Authentication variables are in Secure Files Library for AZDO as a *.auto.tfvars file in the format:
```
    url                 = <your organization URL>
    token               = <token with 'Owner' rights in org>
    tenant_id           = <tenant id of subsription>
    subscription_id     = <subscription id>
    subscription_name   = <subscription name>
```
- Using Azure CLI, use ```az account list``` to find the tenant_id, subscription_id, and subscription_name.
- Secure File should be referenced in Terraform Plan and Terraform Apply steps in the pipeline.

### Pipelines
**Two pipeline files:**
- `terraform-destroy.yaml` will destroy the existing infrastructure.
- `create-az-storage.yaml` will create the backend azurerm storage required to store the terraform state file.

### Test locally with azurerm backend configurations
If you would like to test locally without running through a pipeline:
```
terraform init \
-backend-config=storage_account_name=<storage-account-name> \
-backend-config=container_name=<storage-container-name> \
-backend-config=key=<name-of-file-in-container> \
-backend-config=resource_group_name=<resource-group-name>
```
Followed by:
- `terraform validate`
- `terraform plan`
- `terraform apply`

Destroy the infrastructure with `terraform destroy` when finished.

You can output the kubeconfig files by inputting:
- `terraform output kube_config_dev`
- `terraform output kube_config_staging` 
### Creating storage for local testing
We are following this guide: 
- https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli
- https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-cli

To create the storage:
```
az group create \
  --name <resource-group-name> \
  --location <location>

az storage account create \
  --name <account-name> \
  --resource-group <resource-group-name> \
  --location <location> \
  --sku Standard_RAGRS \
  --kind StorageV2

az storage container create \
    --account-name <account-name> \
    --name tf-state-file-container \
    --auth-mode login
```

To delete the storage resource group:
```
az group delete \
    --name <resource-group> \
    --no-wait
```