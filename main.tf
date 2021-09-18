# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  environment = "dev"
  features {}
}

resource "azurerm_resource_group" "appservice-rg" {
  name = "bitroidapp-service-rg"
  location = "westus"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_app_service_plan" "service-plan" {
  name = "bitroid-service-plan"
  location = azurerm_resource_group.appservice-rg.location
  resource_group_name = azurerm_resource_group.appservice-rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Free"
    size = "F1"
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_app_service" "app-service" {
  name = "bitroidapp-serviceprovider"
  location = azurerm_resource_group.appservice-rg.location
  resource_group_name = azurerm_resource_group.appservice-rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id
  site_config {
    linux_fx_version = "PYTHON|3.8"
    use_32_bit_worker_process = true
  }
  tags = {
    environment = "dev"
  }
}
