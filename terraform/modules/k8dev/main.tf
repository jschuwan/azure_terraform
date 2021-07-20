
provider "kubernetes" {
  alias                  = "dev"
  host                   = "${azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
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
resource "kubernetes_namespace" "may24_devops_dev_t2" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team2"
  }
}
resource "kubernetes_namespace" "may24_devops_dev_t3" {
  provider = kubernetes.dev
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "team3"
  }
}

resource "kubernetes_limit_range" "may24_devops_dev" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits"
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