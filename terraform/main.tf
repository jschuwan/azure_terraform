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
provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "may24_devops_dev" {
    name        = var.resource_group_dev["name"]
    location    = var.resource_group_dev["location"]
}

resource "azurerm_resource_group" "may24_devops_staging" {
    name        = var.resource_group_staging["name"]
    location    = var.resource_group_staging["location"]
}
resource "azurerm_container_registry" "may24_devops_registry" {
    name                = var.container_registry["name"]
    location            = azurerm_resource_group.may24_devops_dev.location
    resource_group_name = azurerm_resource_group.may24_devops_dev.name
    sku                 = "Standard"

    tags = {
          Group                   = "DevOps"
          ContactBeforeDelete     = "Nick Escalona"
          CreatedDate             = timestamp()
    }  
}

resource "azurerm_kubernetes_cluster" "may24_devops_dev" {
    name                = var.kubernetes_cluster_dev["name"]
    location            = azurerm_resource_group.may24_devops_dev.location
    resource_group_name = azurerm_resource_group.may24_devops_dev.name
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
    location            = azurerm_resource_group.may24_devops_staging.location
    resource_group_name = azurerm_resource_group.may24_devops_staging.name
    dns_prefix          = var.kubernetes_cluster_staging["dns_prefix"]

    default_node_pool {
        name                = var.kubernetes_cluster_staging["node_pool_name"]
        node_count          = var.kubernetes_cluster_staging["node_count"]
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
  alias                  = "dev"
  host                   = "${azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team1"
  }
}
resource "kubernetes_namespace" "may24_devops_dev_t2" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_dev_t3" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team3"
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t1"
    namespace = "team1"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t2" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t2"
    namespace = "team2"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t3" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t3"
    namespace = "team3"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

provider "kubernetes" {
  alias                  = "staging"
  host                   = "${azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.cluster_ca_certificate)}"
}
resource "kubernetes_namespace" "may24_devops_staging_t1" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team1"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t2" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t3" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team3"
  }
}

resource "kubernetes_resource_quota" "may24_devops_staging_t1" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t1"
    namespace = "team1"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_staging_t2" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t2"
    namespace = "team2"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_staging_t3" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t3"
    namespace = "team3"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}