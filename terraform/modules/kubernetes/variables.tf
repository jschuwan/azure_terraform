##### Variables referenced from local module
variable "namespaces" {
    type = list
    default = [
        { name = "team1" },{ name = "team2" },{ name = "team3" },{ "name" = "istio-operator" },{ "name" = "istio-system" }
    ]
}
variable "limits" {
    type = list
    default = [
        { name = "may24-staging-resource-limits-t1" },
        { name = "may24-staging-resource-limits-t2" },
        { name = "may24-staging-resource-limits-t3" },
        { name = "may24-istio-operator-limits-t3" },
        { name = "may24-istio-system-limits-t3" }
    ]
}

variable "resource_quota" {
    type = map
    default = {
            cpu     = 3,
            mem     = "6Gi"
    }
}

variable "resource_quota_istio" {
    type = map
    default = {
            cpu     = "200m",
            mem     = "256Mi"
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
