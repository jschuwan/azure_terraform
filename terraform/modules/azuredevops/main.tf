######################### devops
provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/revature-training-uta"
  personal_access_token = "mnj4zgom525w7bhz3a4phyh45u55kwtp5fxzhjkuhejhgyguy3cq"
}

resource "azuredevops_serviceendpoint_azurecr" "azurecr" {
  count = "${length(var.project_id)}"
  project_id             = "${lookup(var.project_id[count.index],"id")}"
  service_endpoint_name  = "${lookup(var.project_id[count.index],"name")}"
  resource_group            = var.resource_group
  azurecr_spn_tenantid      = "6b63e28a-a8f9-47b5-aa40-97e231215164"
  azurecr_name              = var.azurecr_name
  azurecr_subscription_id   = "e37a1117-750a-4552-bb20-e84ed6f3c85d"
  azurecr_subscription_name = "Azure subscription 1"
}