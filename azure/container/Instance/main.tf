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

resource "azurerm_container_group" "aci" {
  name                = var.instance_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_address_type     = "public"
  dns_name_label      = "aci-first-container01"
  os_type             = "Linux"

  container {
    name   = "myfirstproject"
    image  = "${data.terraform_remote_state.registry.outputs.container-registry-server-name}/sampleapi:v1"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
        server = data.terraform_remote_state.registry.outputs.container-registry-server-name
        username = data.terraform_remote_state.registry.outputs.container-registry-admin-user-name
        password = data.terraform_remote_state.registry.outputs.container-registry-admin-password // We should use Vault to reterive the password

    }

  tags = {
    environment = "testing"
  }
}