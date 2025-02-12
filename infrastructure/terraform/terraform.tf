terraform {
  required_version = ">=0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.110.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.13.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}
