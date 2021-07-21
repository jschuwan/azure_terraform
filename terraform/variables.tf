variable "resource_group" {
# Replace with your own values if this is used as a template
    type = map
    default = {
        "name"      = "may24_devops_group"
        "location"  = "Central US"
    }
}

variable "container_registry" {
    type = map
    default = {
        "name" = "may24DevOpsContainers"
    }                  
}

variable "kubernetes_cluster_dev" {
    type = map
    default = {
        "name"              = "may24_devops_aks_dev"
        "dns_prefix"        = "may24-devops-dev"
        "node_count"        = 3
        "node_pool_name"    = "development"
    }
}

variable "kubernetes_cluster_staging" {
    type = map
    default = {
        "name"              = "may24_devops_aks_staging"
        "dns_prefix"        = "may24-devops-staging"
        "node_count"        = 3
        "node_pool_name"    = "staging"        
    }
}