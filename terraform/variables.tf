# variable "serviceprinciple_id" {}
# variable "subscription_id" {}
# variable "serviceprinciple_key" {}
# variable "tenant_id" {}

variable "appId" {
    default = "f47a811a-8ef4-480b-9038-a08b6116d0c7"
}
variable "password" {
    default = "ad2db723-0b3b-46d9-9849-9a72cced79df"
}

variable "resource_group" {
# Replace with your own values if this is used as a template
    type = map
    default = {
        "name"      = "may24_devops"
        "location"  = "East US"
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
