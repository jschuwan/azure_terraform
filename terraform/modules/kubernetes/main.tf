provider "kubernetes" {
  alias                  = "dev"
  host                   = var.cluster_dev.host
  client_certificate     = var.cluster_dev.client_certificate
  client_key             = var.cluster_dev.client_key
  cluster_ca_certificate = var.cluster_dev.ca_certificate
}

resource "kubernetes_namespace" "may24_devops_dev" {
  provider = kubernetes.dev
  count = "${length(var.namespaces)}"
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "${lookup(var.namespaces[count.index],"name")}"
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  count = "${length(var.namespaces)}"
  metadata {
    name = "${lookup(var.limits[count.index],"name")}"
    namespace = "${lookup(var.namespaces[count.index],"name")}"
  }
  spec {
    hard = {
      "limits.cpu" = 4
      "limits.memory" = "6Gi"
    }
  }
}

provider "kubernetes" {
  alias                  = "staging"
  host                   = var.cluster_staging.host
  client_certificate     = var.cluster_staging.client_certificate
  client_key             = var.cluster_staging.client_key
  cluster_ca_certificate = var.cluster_staging.ca_certificate
}

resource "kubernetes_namespace" "may24_devops" {
  provider = kubernetes.staging
  count = "${length(var.namespaces)}"
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "${lookup(var.namespaces[count.index],"name")}"
  }
}

resource "kubernetes_resource_quota" "may24_devops" {
  provider = kubernetes.staging
  count = "${length(var.namespaces)}"
  metadata {
    name = "${lookup(var.limits[count.index],"name")}"
    namespace = "${lookup(var.namespaces[count.index],"name")}"
  }
  spec {
    hard = {
      "limits.cpu" = 4
      "limits.memory" = "6Gi"
    }
  }
}