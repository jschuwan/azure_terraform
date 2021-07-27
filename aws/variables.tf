variable "region" {
    type = string
    default = "us-west-2"
  
}

variable "vpc" {
    type = map
    default = {
        name            = "testing-vpc"
        cidr            = "192.168.0.0/16"
    }
}

variable "iam_roles" {
    type = map
    default = {
        eks_cluster_role    = "eks-cluster-role"
        eks_node_role       = "trg-cluster-nodegrp-role"
    }
}

variable "public_subnets" {
    type = list
    default = [
        {"name" = "192.168.0.0/18"},
        {"name" = "192.168.64.0/18"}
    ]
}

variable "private_subnets" {
    type = list
    default = [
        {"name" = "192.168.128.0/18"},
        {"name" = "192.168.192.0/18"}
    ]    
}

variable "aws_iam_eks_user" {
    type    = string
    default = "trainer-name-batchNo-p3-access"
}

variable "aws_iam_user_policy" {
    type    = string
    default = "user_policy"
}

variable "aws_eks_cluster" {
    type    = map
    default = {
        name    = "default-cluster-name"
        version = "1.17"
    }
}

variable "aws_eks_node_group_name" {
    type    = string
    default = "default-node-group"
}

variable "scaling_config" {
    type    = map
    default = {
        desired_size    = 1
        max_size        = 1
        min_size        = 1
    }
}