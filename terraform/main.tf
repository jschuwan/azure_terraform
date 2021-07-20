terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.60.0"
        }
         kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.3.2"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "may24_devops" {
    name        = var.resource_group["name"]
    location    = var.resource_group["location"]
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

resource "azurerm_kubernetes_cluster" "may24_devops_dev" {
    name                = var.kubernetes_cluster_dev["name"]
    location            = azurerm_resource_group.may24_devops.location
    resource_group_name = azurerm_resource_group.may24_devops.name
    dns_prefix          = var.kubernetes_cluster_dev["dns_prefix"]

    default_node_pool {
        name                = var.kubernetes_cluster_dev["node_pool_name"]
        node_count          = var.kubernetes_cluster_dev["node_count"]
        vm_size             = "Standard_DS2_v2"
        #enable_auto_scaling = false
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

resource "azurerm_kubernetes_cluster" "may24_devops_staging" {
    name                = var.kubernetes_cluster_staging["name"]
    location            = azurerm_resource_group.may24_devops.location
    resource_group_name = azurerm_resource_group.may24_devops.name
    dns_prefix          = var.kubernetes_cluster_staging["dns_prefix"]

    default_node_pool {
        name                = var.kubernetes_cluster_staging["node_pool_name"]
        node_count          = var.kubernetes_cluster_staging["node_count"]
        vm_size             = "Standard_DS2_v2"
        #enable_auto_scaling = false
    }

    role_based_access_control {
      enabled = true
    }

    identity {
        type = "SystemAssigned"
    }

    tags = {
        Group                   = "DevOps"
        Environment             = "staging"
        ContactBeforeDelete     = "Nick Escalona"
        CreatedDate             = timestamp()
    }
}

output "kube_config_dev" {
    value = azurerm_kubernetes_cluster.may24_devops_dev.kube_config_raw
    sensitive = true
}

output "kube_config_staging" {
    value = azurerm_kubernetes_cluster.may24_devops_staging.kube_config_raw
    sensitive = true
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_limit_range" "may24_devops_dev" {
  metadata {
    name = "may24-dev-resource-limits"
  }
  spec {
    limit {
      type = "Pod"
      max = {
        cpu    = "1000m"
        memory = "1024Mi"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "1000m"
        memory = "1024Mi"
      }
    }
  }
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_limit_range" "may24_devops_staging" {
  metadata {
    name = "may24-staging-resource-limits"
  }
  spec {
    limit {
      type = "Pod"
      max = {
        cpu    = "1000m"
        memory = "1048Mi"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "1000m"
        memory = "1024Mi"
      }
    }
  }
}