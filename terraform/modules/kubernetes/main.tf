provider "kubernetes" {
  alias                  = "dev"
  host                   = "${module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.host}"
  client_certificate     = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_dev.kube_config.0.cluster_ca_certificate)}"
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

resource "kubernetes_resource_quota" "may24_devops_dev_t1" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t1"
    namespace = "team1"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t2" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t2"
    namespace = "team2"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_dev_t3" {
  provider = kubernetes.dev
  metadata {
    name = "may24-dev-resource-limits-t3"
    namespace = "team3"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

provider "kubernetes" {
  alias                  = "staging"
  host                   = "${module.azure.azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.host}"
  client_certificate     = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(module.azure.azurerm_kubernetes_cluster.may24_devops_staging.kube_config.0.cluster_ca_certificate)}"
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

resource "kubernetes_resource_quota" "may24_devops_staging_t1" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t1"
    namespace = "team1"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_staging_t2" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t2"
    namespace = "team2"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}

resource "kubernetes_resource_quota" "may24_devops_staging_t3" {
  provider = kubernetes.staging
  metadata {
    name = "may24-staging-resource-limits-t3"
    namespace = "team3"    
  }
  spec {
    hard = {
      "limits.cpu" = 3
      "limits.memory" = "6Gi"
    }
  }
}