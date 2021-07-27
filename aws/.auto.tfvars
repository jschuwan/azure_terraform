variable "vpc" {
    type = map
    default = {
        name            = "testing-vpc",
        cidr            = "192.168.0.0/16",
    }
}

variable "iam_roles" {
    type = map
    default = {
        eks_cluster_role    = "eks_cluster_role",
        eks_node_role       = "eks_node_role"
    }
}