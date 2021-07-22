
module "azure" {
  source = "./modules/azure"
}

module "kubernetes" {
  source = "./modules/kubernetes"

  kubeconfig = module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config
}

