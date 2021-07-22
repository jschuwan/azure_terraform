##### Variables referenced from local module
variable "project_info" {
    type = map
    default = {
            "url"     = "https://dev.azure.com/revature-training-uta"
            "token"   = "foxdoargbo4wieypydpjgmkpieqf7mwf25pldnm76sufzszfc6bq"   
    }
}

variable "account_info" {
    type = map
    default = {
            # "tenant_id"           = "6b63e28a-a8f9-47b5-aa40-97e231215164"
            # "subscription_id"     = "e37a1117-750a-4552-bb20-e84ed6f3c85d"
            # "subscription_name"   = "Azure subscription 1"
            "tenant_id"           = "b8d0218e-2df0-43d0-b94d-83162050b011"
            "subscription_id"     = "5198ab11-bed1-4a17-9205-df35c05f87b9"
            "subscription_name"   = "Azure subscription 1"
    }
}

variable "project_id" {
    type = list
    default = [
        {
            name    = "acr-common",
            id      = "9a591d1a-b59e-4089-a839-aaf3cf17a3a9"
        },
        {
            name    = "acr-team1",
            id      = "d6293b30-b115-4508-b81b-a6c0d733cfa0"
        },
        {
            name    = "acr-team2",
            id      = "eb90657a-0d4f-4efc-ab88-854ac581c5a8"
        },
        {
            name    = "acr-team3",
            id      = "d2963c1a-e6cb-47b0-8d51-e0051b0d446e"
        },
    ]
}

##### Variables referenced from main module
variable "resource_group" {
    type = string
}

variable "azurecr_name" {
    type = string
}
