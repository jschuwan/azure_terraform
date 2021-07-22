provider "kubernetes" {
  alias                  = "dev"
  host                   = var.cluster_host
  client_certificate     = var.cluster_client_certificate
  client_key             = var.cluster_client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_namespace" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team1"
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t1"
    namespace = "team1"    
  }
  spec {
    hard = {
      "limits.cpu" = 2
      "limits.memory" = "2Gi"
    }
  }
}