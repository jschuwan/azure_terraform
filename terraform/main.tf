terraform {

    #backenstoage in terraform cloud 
    backend "remote"{
        organization = "may24_devops_p3"
        token        = "5nQYNwLfbxMLHg.atlasv1.oKiOE2twkzYlT2m2fhqQPtbO3WffhBQyuKDWATvVyJcpyJT6ckhvWzJfMzZ27mymwj8"
    

      workspaces{
          name = "project3-common"
      }
    }
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
  alias                  = "dev"
  host                   = "${azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "may24_devops_dev_t1" {
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team1"
  }
}
resource "kubernetes_namespace" "may24_devops_dev_t2" {
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_dev_t3" {
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team3"
  }
}

resource "kubernetes_limit_range" "may24_devops_dev" {
  metadata {
    name = "may24-dev-resource-limits"
  }
  spec {
    limit {
      type = "Namespace"
      max = {
        cpu    = "5000m"
        memory = "5120Mi"
      }
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
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team1"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t2" {
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t3" {
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team3"
  }
}

resource "kubernetes_limit_range" "may24_devops_staging" {
  metadata {
    name = "may24-staging-resource-limits"
  }
  spec {
    limit {
      type = "Namespace"
      max = {
        cpu    = "5000m"
        memory = "5120Mi"
      }
    }
  }
}