variable "resource_group" {
    type = string
}

variable "azurecr_name" {
    type = string
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