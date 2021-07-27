terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.3.2"
    }
  }
}

provider "kubernetes" {
  host                    = var.host
  cluster_ca_certificate  = var.provider
  token                   = var.token
}
