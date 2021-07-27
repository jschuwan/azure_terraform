terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.3.2"
    }
  }
}

provider "kubernetes" {
  host                    = var.host
  cluster_ca_certificate  = var.cluster_ca_certificate
  token                   = var.token
}

##### namespace configurations here #####
