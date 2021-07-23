##### Manifest is configured for 2 resource groups, each with an AKS cluster
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
            "node_count"        = 1,
            "node_pool_name"    = "development"
            "vm_size"           = "Standard_DS2_v2"
        },
        {
            "name"              = "may24_devops_aks_staging",
            "dns_prefix"        = "may24-devops-staging",
            "node_count"        = 1,
            "node_pool_name"    = "staging"        
            "vm_size"           = "Standard_DS2_v2"
        }
    ]
}
variable "container_registry" {
    type = map
    default = {
        "name" = "Zmay24DevOpsContainers"
    }                  
}

variable "resource_tags" {
    type = map
    default = {
        group       = "DevOps"
        contact     = "Nick Escalona"
    }
}