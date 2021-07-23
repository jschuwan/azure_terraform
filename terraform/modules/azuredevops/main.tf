######################### devops
provider "azuredevops" {
  org_service_url       = var.project_info.url
  personal_access_token = var.project_info.token
}

resource "azuredevops_serviceendpoint_azurecr" "azurecr" {
  count                     = "${length(var.project_id)}"
  project_id                = "${lookup(var.project_id[count.index],"id")}"
  service_endpoint_name     = "${lookup(var.project_id[count.index],"name")}"
  resource_group            = var.resource_group
  azurecr_spn_tenantid      = var.account_info.tenant_id
  azurecr_name              = var.azurecr_name
  azurecr_subscription_id   = var.account_info.subscription_id
  azurecr_subscription_name = var.account_info.subscription_name
}

resource "azuredevops_serviceendpoint_kubernetes" "k8_dev" {
  count                 = "${length(var.project_id)}"
  project_id            = "${lookup(var.project_id[count.index], "id")}"
  service_endpoint_name = "k8_dev_cluster"
  apiserver_url         = "${azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.host}"
  authorization_type    = "AzureSubscription"

  azure_subscription {
    subscription_id   = var.account_info.subscription_id
    subscription_name = var.account_info.subscription_name
    tenant_id         = var.account_info.tenant_id
    resourcegroup_id  = var.resource_group
    namespace         = "${lookup(var.project_id[count.index], "namespace")}"
    cluster_name      = "${azurerm_kubernetes_cluster.may24_devops.0.kube_config.0.name}"
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "k8_staging" {
  count                 = "${length(var.project_id)}"
  project_id            = "${lookup(var.project_id[count.index], "id")}"
  service_endpoint_name = "k8_stage_cluster"
  apiserver_url         = "${azurerm_kubernetes_cluster.may24_devops.1.kube_config.1.host}"
  authorization_type    = "AzureSubscription"

  azure_subscription {
    subscription_id   = var.account_info.subscription_id
    subscription_name = var.account_info.subscription_name
    tenant_id         = var.account_info.tenant_id
    resourcegroup_id  = var.resource_group
    namespace         = "${lookup(var.project_id[count.index], "namespace")}"
    cluster_name      = "${azurerm_kubernetes_cluster.may24_devops.1.kube_config.1.name}"
  }
}