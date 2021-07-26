##### Variables referenced from local module
variable "namespaces" {
    type = list
    default = [
        { name = "team1" },{ name = "team2" },{ name = "team3" }, { name = "istio" }
    ]
}
variable "limits" {
    type = list
    default = [
        { name = "may24-resource-limits-t1" },
        { name = "may24-resource-limits-t2" },
        { name = "may24-resource-limits-t3" },
        { name = "may24-resource-limits-istio" }
    ]
}

variable "resource_quota" {
    type = map
    default = {
            cpu     = 3,
            mem     = "6Gi"
    }
}

##### Variables referenced from main module
variable "cluster_dev" {
    type = map
    default = {
        "host" = "",
        "client_certificate" = "",
        "client_key" = "",
        "cluster_ca_certificate" = ""
    }
}

variable "cluster_staging" {
    type = map
    default = {
        "host" = "",
        "client_certificate" = "",
        "client_key" = "",
        "cluster_ca_certificate" = ""
    }
}
