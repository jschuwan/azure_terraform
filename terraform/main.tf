
module "azure" {
  source = "./modules/azure"
}

module "kubernetes" {
  source = "./modules/kubernetes"
  kube_config = module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config
}

