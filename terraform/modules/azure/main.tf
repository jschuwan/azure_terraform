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

    lifecycle {
      ignore_changes = [
        tags["CreatedDate"]
      ]
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

    lifecycle {
      ignore_changes = [
        tags["CreatedDate"]
      ]
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

    lifecycle {
      ignore_changes = [
        tags["CreatedDate"]
      ]
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

output "kube_config_0_dev" {
    value = azurerm_kubernetes_cluster.may24_devops_dev.kube_config
}
