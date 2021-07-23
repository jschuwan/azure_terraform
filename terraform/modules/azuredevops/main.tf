######################### devops
provider "azuredevops" {
  org_service_url       = var.url
  personal_access_token = var.token
}
resource "azuredevops_serviceendpoint_azurecr" "azurecr" {
  count = "${length(var.project_id)}"
  project_id             = "${lookup(var.project_id[count.index],"id")}"
  service_endpoint_name  = "${lookup(var.project_id[count.index],"name")}"
  resource_group            = var.resource_group
  azurecr_spn_tenantid      = var.tenant_id
  azurecr_name              = var.azurecr_name
  azurecr_subscription_id   = var.subscription_id
  azurecr_subscription_name = var.subscription_name
}
