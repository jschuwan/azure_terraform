
provider "kubernetes" {
  alias                  = "staging"
  host                   = "${azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.cluster_ca_certificate)}"
}
resource "kubernetes_namespace" "may24_devops_staging_t1" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team1"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t2" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_staging_t3" {
  provider = kubernetes.staging
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "team3"
  }
}

resource "kubernetes_limit_range" "may24_devops_staging" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits"
  }
   spec {
    limit {
      type = "Pod"
      max = {
        cpu    = "1000m"
        memory = "1024Mi"
      }
    }
  }
}