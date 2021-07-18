terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.60.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "may24_devops" {
    name        = var.resource_group["name"]
    location    = var.resource_group["location"]
}

