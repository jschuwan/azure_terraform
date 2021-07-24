######################### devops
provider "azuredevops" {
  org_service_url           = var.project_info
  personal_access_token     = var.token
}
resource "azuredevops_serviceendpoint_azurecr" "azurecr" {
  count                     = "${length(var.project_id)}"
  project_id                = "${lookup(var.project_id[count.index],"id")}"
  service_endpoint_name     = "${lookup(var.project_id[count.index],"name")}"
  resource_group            = var.resource_group
  azurecr_spn_tenantid      = var.tenant_id
  azurecr_name              = var.azurecr_name
  azurecr_subscription_id   = var.subscription_id
  azurecr_subscription_name = var.subscription_name
}

resource "azuredevops_serviceendpoint_kubernetes" "k8s_svc_dev" {
  count                     = "${length(var.k8s_id)}"
  project_id                = "${lookup(var.k8s_id[count.index], "id")}"
  service_endpoint_name     = "${lookup(var.k8s_id[count.index], "name")}-config-dev"
  apiserver_url             = var.k8s_svc_url_dev
  authorization_type        = "AzureSubscription"
  azure_subscription {
    subscription_id         = var.subscription_id
    subscription_name       = var.subscription_name
    tenant_id               = var.tenant_id
    resourcegroup_id        = "${lookup(var.k8s_resource_groups.0, "name")}"
    namespace               = "${lookup(var.k8s_namespaces[count.index], "name")}"
    cluster_name            = "${lookup(var.k8s_cluster_names.0, "name")}"
  }
   
}

resource "azuredevops_serviceendpoint_kubernetes" "k8s_svc_staging" {
  count                     = "${length(var.k8s_id)}"
  project_id                = "${lookup(var.k8s_id[count.index], "id")}"
  service_endpoint_name     = "${lookup(var.k8s_id[count.index], "name")}-config-staging"
  apiserver_url             = var.k8s_svc_url_staging
  authorization_type        = "AzureSubscription"
  azure_subscription {
    subscription_id         = var.subscription_id
    subscription_name       = var.subscription_name
    tenant_id               = var.tenant_id
    resourcegroup_id        = "${lookup(var.k8s_resource_groups.1, "name")}"
    namespace               = "${lookup(var.k8s_namespaces[count.index], "name")}"
    cluster_name            = "${lookup(var.k8s_cluster_names.1, "name")}"
  }
   
}