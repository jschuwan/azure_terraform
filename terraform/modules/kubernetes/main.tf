provider "kubernetes" {
  alias                  = "dev"
  host                   = var.cluster_dev.host
  client_certificate     = var.cluster_dev.client_certificate
  client_key             = var.cluster_dev.client_key
  cluster_ca_certificate = var.cluster_dev.cluster_ca_certificate
}

resource "kubernetes_namespace" "dev" {
  provider = kubernetes.dev
  count = "${length(var.namespaces)}"
  metadata {
    labels = {
      group = "may24-dev"
    }
    name = "${lookup(var.namespaces[count.index],"name")}"
  }
}

resource "kubernetes_resource_quota" "dev" {
  provider = kubernetes.dev
  count = "${length(var.namespaces)}"
  metadata {
    name = "${lookup(var.limits[count.index],"name")}"
    namespace = "${lookup(var.namespaces[count.index],"name")}"
  }
  spec {
    hard = {
      "limits.cpu"    = "${count.index}" < 3 ? var.resource_quota.cpu : var.resource_quota_istio.cpu
      "limits.memory" = "${count.index}" < 3 ? var.resource_quota.mem : var.resource_quota_istio.mem
    }
  }
}

provider "kubernetes" {
  alias                  = "staging"
  host                   = var.cluster_staging.host
  client_certificate     = var.cluster_staging.client_certificate
  client_key             = var.cluster_staging.client_key
  cluster_ca_certificate = var.cluster_staging.cluster_ca_certificate
}

resource "kubernetes_namespace" "staging" {
  provider = kubernetes.staging
  count = "${length(var.namespaces)}"
  metadata {
    labels = {
      group = "may24-staging"
    }
    name = "${lookup(var.namespaces[count.index],"name")}"
  }
}

resource "kubernetes_resource_quota" "staging" {
  provider = kubernetes.staging
  count = "${length(var.namespaces)}"
  metadata {
    name = "${lookup(var.limits[count.index],"name")}"
    namespace = "${lookup(var.namespaces[count.index],"name")}"
  }
  spec {
    hard = {
      "limits.cpu"    = "${count.index}" < 3 ? var.resource_quota.cpu : var.resource_quota_istio.cpu
      "limits.memory" = "${count.index}" < 3 ? var.resource_quota.mem : var.resource_quota_istio.mem
    }
  }
}