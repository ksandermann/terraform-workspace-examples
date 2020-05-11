terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = "~>2.7.0"

  environment     = "Public"
  tenant_id       = "supersecrret"
  subscription_id = "supersecrret"

  features {}
}
