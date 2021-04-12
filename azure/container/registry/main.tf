terraform {
  required_version = ">= 0.12.6"
  required_providers {
    azurerm = {
      version = "~> 2.53.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  skip_provider_registration = true
}

/*resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}*/

resource "azurerm_container_registry" "acr" {
  name                     = var.registry_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  sku                      = "Standard"
  admin_enabled            = true
}