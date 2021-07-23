# Terraform configuration for Project 3
## Modules
### AzureRM
- Main module, used to create AzureRM resource groups, clusters, and container registry
### Kubernetes
- Module used to configure Kubernetes namespaces and resource quotas
### AzureDevops
- Module used to create service connections
- Module should be uncommented in main.tf for use (authentication variables should be set in modules/azuredevops/variables.tf first)
