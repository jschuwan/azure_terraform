# Manifest is configured 
variable "resource_groups" {
    type = list
    default = [
        {
            "name"      = "may24_devops_dev",
            "location"  = "Central US"
        },
        {
            "name"      = "may24_devops_staging",
            "location"  = "South Central US"
        }
    ]
}
variable "kubernetes_clusters" {
    type = list
    default = [
        {
            "name"              = "may24_devops_aks_dev",
            "dns_prefix"        = "may24-devops-dev",
            "node_count"        = 3,
            "node_pool_name"    = "development"
        },
        {
            "name"              = "may24_devops_aks_staging",
            "dns_prefix"        = "may24-devops-staging",
            "node_count"        = 3,
            "node_pool_name"    = "staging"        
        }
    ]
}
variable "container_registry" {
    type = map
    default = {
        "name" = "may24DevOpsContainers"
    }                  
}

variable "resource_tags" {
    type = map
    default = {
        group       = "DevOps"
        contact     = "Nick Escalona"
    }
}