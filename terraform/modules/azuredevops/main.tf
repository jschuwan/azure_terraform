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