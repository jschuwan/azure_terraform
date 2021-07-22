variable "resource_group_dev" {
# Replace with your own values if this is used as a template
    type = map
    default = {
        "name"      = "may24_devops_dev"
        "location"  = "Central US"
    }
}

variable "resource_group_staging" {
# Replace with your own values if this is used as a template
    type = map
    default = {
        "name"      = "may24_devops_staging"
        "location"  = "South Central US"
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
#Azure devops vaiables 

#id for the projects you wish to add service connection to 
variable "ado_poject_id"{
    type = list(string)
}
#name of the service connection you wich to create
vaiable "service_endpoint_name" {
    type = string 
}
#url of the org projects are part of 
variable "ado_org_url" {
    type = string
}
#token for access to orginization 
varialbe "ado_token" {
    type = string 

}


