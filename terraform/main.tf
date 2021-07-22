terraform {
   required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.60.0"
        }
         kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.3.2"
            configuration_aliases = [ kubernetes.dev, kubernetes.staging ]
        }
    }
}
module "azure" {
  source = "./modules/azure"
}

module "kubernetes" {
  source = "./modules/kubernetes"

  kube_config_0_dev = kubeconfig
}

