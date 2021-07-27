# Terraform configuration for Project 3
## Modules
### AzureRM
- Main module, used to create AzureRM resource groups, clusters, and container registry
### Kubernetes
- Module used to configure Kubernetes namespaces and resource quotas
### AzureDevops
- Module used to create service connections for ACR
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
**Two pipelines files:**
- `terraform-destroy.yaml` will destroy the existing infrastructure.
- `create-az-storage.yaml` will create the backend azurerm storage required to store the terraform state file.