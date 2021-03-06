terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.60.0"
        }
    }

   backend "azurerm" {}
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
    location            = azurerm_resource_group.may24_devops.0.location
    resource_group_name = azurerm_resource_group.may24_devops.0.name
    sku                 = "Standard"

    tags = {
      Group                   = var.resource_tags.group
      ContactBeforeDelete     = var.resource_tags.contact
      CreatedDate             = timestamp()
    }

    lifecycle {
      ignore_changes = [
        tags["CreatedDate"]
      ]
    }  
}

resource "azurerm_kubernetes_cluster" "may24_devops" {
    count                   = "${length(var.kubernetes_clusters)}"
    name                    = "${lookup(var.kubernetes_clusters[count.index],"name")}"
    location                = azurerm_resource_group.may24_devops[count.index].location
    resource_group_name     = azurerm_resource_group.may24_devops[count.index].name
    dns_prefix              = "${lookup(var.kubernetes_clusters[count.index],"dns_prefix")}"
    default_node_pool {
        name                = "${lookup(var.kubernetes_clusters[count.index],"node_pool_name")}"
        node_count          = "${lookup(var.kubernetes_clusters[count.index],"node_count")}"
        vm_size             = "${lookup(var.kubernetes_clusters[count.index],"vm_size")}"
    }

    role_based_access_control {
      enabled = true
    }

    identity {
        type = "SystemAssigned"
    }

    tags = {
      Group                   = var.resource_tags.group
      ContactBeforeDelete     = var.resource_tags.contact
      CreatedDate             = timestamp()
    }
    
    lifecycle {
      ignore_changes = [
        tags["CreatedDate"]
      ]
    }  
}

output "kube_config_dev" {
    value     = azurerm_kubernetes_cluster.may24_devops.0.kube_config_raw
    sensitive = true
}
output "kube_config_staging" {
    value     = azurerm_kubernetes_cluster.may24_devops.1.kube_config_raw
    sensitive = true
}

module "kubernetes" {
  source = "./modules/kubernetes"
  cluster_dev = { 
    "host"                        = "${azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.host}",
    "client_certificate"          = "${base64decode(azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.client_certificate)}",
    "client_key"                  = "${base64decode(azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.client_key)}",
    "cluster_ca_certificate"      = "${base64decode(azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.cluster_ca_certificate)}"
  }

  cluster_staging = { 
    "host"                        = "${azurerm_kubernetes_cluster.may24_devops.1.kube_config.0.host}",
    "client_certificate"          = "${base64decode(azurerm_kubernetes_cluster.may24_devops.1.kube_config.0.client_certificate)}",
    "client_key"                  = "${base64decode(azurerm_kubernetes_cluster.may24_devops.1.kube_config.0.client_key)}",
    "cluster_ca_certificate"      = "${base64decode(azurerm_kubernetes_cluster.may24_devops.1.kube_config.0.cluster_ca_certificate)}"
  }
}

module "azuredevops" {
  source = "./modules/azuredevops"

  resource_group          = azurerm_resource_group.may24_devops.0.name
  azurecr_name            = azurerm_container_registry.may24_devops_registry.name
  k8s_svc_url_dev         = azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.host
  k8s_svc_url_staging     = azurerm_kubernetes_cluster.may24_devops.1.kube_config.0.host
  k8s_resource_groups     = var.resource_groups
  k8s_cluster_names       = var.kubernetes_clusters 
  project_info            = var.url
  token                   = var.token
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  subscription_name       = var.subscription_name
}