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

variable "namespaces" {
    type = list
    default = [
        { name = "team1" },{ name = "team2" },{ name = "team3" }
    ]
}
variable "limits" {
    type = list
    default = [
        { name = "may24-staging-resource-limits-t1" },
        { name = "may24-staging-resource-limits-t2" },
        { name = "may24-staging-resource-limits-t3" }
    ]
}