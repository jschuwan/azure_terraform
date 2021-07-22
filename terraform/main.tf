terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.60.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "may24_devops" {
    count     = "${length(var.resource_groups)}"
    name      = "${lookup(var.resource_groups[count.index],"name")}"
    location  = "${lookup(var.resource_groups[count.index],"location")}"
}

resource "azurerm_container_registry" "may24_devops_registry" {
    name                = var.container_registry["name"]
    location            = azurerm_resource_group.may24_devops.location
    resource_group_name = azurerm_resource_group.may24_devops.name
    sku                 = "Standard"

    tags = {
          Group                   = "DevOps"
          ContactBeforeDelete     = "Nick Escalona"
          CreatedDate             = timestamp()
    }  
}

resource "azurerm_kubernetes_cluster" "may24_devops" {
    count                   = "${length(var.kubernetes_clusters)}"
    name                    = "${lookup(var.kubernetes_clusters[count.index],"name")}"
    location                = "${lookup(var.resource_groups[count.index],"location")}"
    resource_group_name     = "${lookup(var.resource_groups[count.index],"name")}"
    dns_prefix              = "${lookup(var.kubernetes_clusters[count.index],"dns_prefix")}"
    default_node_pool {
        name                = "${lookup(var.kubernetes_clusters[count.index],"node_pool_name")}"
        node_count          = "${lookup(var.kubernetes_clusters[count.index],"node_count")}"
        vm_size             = "Standard_DS2_v2"
    }

    role_based_access_control {
      enabled = true
    }

    identity {
        type = "SystemAssigned"
    }

    tags = {
        Group                   = "DevOps"
        Environment             = "dev"
        ContactBeforeDelete     = "Nick Escalona"
        CreatedDate             = timestamp()
    }
}
output "kube_config_dev" {
    value = azurerm_kubernetes_cluster.may24_devops.0.kube_config_raw
    sensitive = true
}
output "kube_config_staging" {
    value = azurerm_kubernetes_cluster.may24_devops.1.kube_config_raw
    sensitive = true
}


module "kubernetes" {
  source = "./modules/kubernetes"
  cluster_dev = { 
    "host"                = "${azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}",
    "client_certificate"  = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}",
    "client_key"          = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}",
    "cluster_ca_certificate"      = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
  }

  cluster_staging = { 
    "host"                = "${azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.host}",
    "client_certificate"  = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_certificate)}",
    "client_key"          = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_key)}",
    "cluster_ca_certificate"      = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.cluster_ca_certificate)}"
  }
}
module "azuredevops" {
  source = "./modules/azuredevops"

  resource_group = azurerm_resource_group.may24_devops.name
  azurecr_name = azurerm_container_registry.may24_devops_registry.name    
}