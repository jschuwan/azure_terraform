# How do we get kube_config files as artifacts?

# Provides the config file to connect to AKS cluster
output "kube_config_dev" {
    value = azurerm_kubernetes_cluster.may24_devops_dev.kube_config_raw
    sensitive = true
}

output "kube_config_staging" {
    value = azurerm_kubernetes_cluster.may24_devops_staging.kube_config_raw
    sensitive = true
}

# terraform output configure
# Probably want this in a separate outputs.tf file?
output "configure" {
    value = <<CONFIGURE

Run the following commands to configure the kubernetes client:

terraform output kube_config_dev > ~/.kube/may24_devops_config_dev
terraform output kube_config_staging > ~/.kube/may24_devops_config_staging
export KUBECONFIG=~/.kube/may24_devops_config

Test configuration using kubectl:

kubectl get nodes
CONFIGURE
}