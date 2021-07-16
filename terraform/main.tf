terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group for Development
resource "azurerm_resource_group" "devopsDev" {
  name     = "devops_resource_group_dev"
  location = "eastus"
  tags = {
    Group                 = "DevOps"
    Environment           = "Development"
    ContactBeforeDelete   = "NickEscalona"
    CreatedDate           = timestamp()
  }  
}

# Resource Group for Staging
resource "azurerm_resource_group" "devopsStaging" {
  name     = "devops_resource_group_staging"
  location = "centralus"

  tags = {
    Group                 = "DevOps"
    Environment           = "Staging"
    ContactBeforeDelete   = "NickEscalona"
    CreatedDate           = timestamp()
  }  
}

# Azure Container Registry
resource "azurerm_container_registry" "devops" {
  name                  = "DevOpsMay2021ACR"
  resource_group_name   = azurerm_resource_group.devopsDev.name
  location              = azurerm_resource_group.devopsDev.location
  sku                   = "Standard"

  tags = {
    Group                 = "DevOps"
    ContactBeforeDelete   = "NickEscalona"
    CreatedDate           = timestamp()
  }  
}

# Development Cluster and Node Pool
resource "azurerm_kubernetes_cluster" "devopsDev" {
  name                = "devops_dev_cluster"
  location            = azurerm_resource_group.devopsDev.location
  resource_group_name = azurerm_resource_group.devopsDev.name
  dns_prefix          = "devops-p3-dev"

  default_node_pool {
      name        = "development"
      node_count  = 3
      vm_size     = "Standard_DS2_v2"
    }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Group                 = "DevOps"
    Environment           = "Development"
    ContactBeforeDelete   = "NickEscalona"
    CreatedDate           = timestamp()
  }  
}

# Staging Cluster and Node Pool
resource "azurerm_kubernetes_cluster" "devopsStaging" {
  name                = "devops_staging_cluster"
  location            = azurerm_resource_group.devopsStaging.location
  resource_group_name = azurerm_resource_group.devopsStaging.name
  dns_prefix          = "devops-p3-staging"

  default_node_pool {
      name        = "staging"
      node_count  = 3
      vm_size     = "Standard_DS2_v2"
    }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Group                 = "DevOps"
    Environment           = "Staging"
    ContactBeforeDelete   = "NickEscalona"
    CreatedDate           = timestamp()
  }  
}

output "client_certificate_dev" {
  value       = azurerm_kubernetes_cluster.devopsDev.kube_config.0.client_certificate
  description = "Client Certificate for Development Cluster"
}

output "kube_config_dev" {
  value       = azurerm_kubernetes_cluster.devopsDev.kube_config_raw
  description = "KubeConfig for Development Cluster"
}

output "client_certificate_staging" {
  value       = azurerm_kubernetes_cluster.devopsStaging.kube_config.0.client_certificate
  description = "Client Certificate for Staging Cluster"
}

output "kube_config_staging" {
  value       = azurerm_kubernetes_cluster.devopsStaging.kube_config_raw
  description = "KubeConfig for Staging Cluster"
}