######################### devops
provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/revature-training-uta"
  personal_access_token = "mnj4zgom525w7bhz3a4phyh45u55kwtp5fxzhjkuhejhgyguy3cq"
}

resource "azuredevops_serviceendpoint_azurecr" "azurecr" {
  project_id             = "49c70608-1d8c-4622-baa7-e11442ca8dc0"
  service_endpoint_name  = "Sample AzureCR"
  resource_group            = var.resource_group
  azurecr_spn_tenantid      = "b8d0218e-2df0-43d0-b94d-83162050b011"
  azurecr_name              = var.azurecr_name
  azurecr_subscription_id   = "5198ab11-bed1-4a17-9205-df35c05f87b9"
  azurecr_subscription_name = "Azure subscription 1"
}

# revtenant_id: 6b63e28a-a8f9-47b5-aa40-97e231215164

