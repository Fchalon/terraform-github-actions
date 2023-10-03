terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
   backend "azurerm" {
    resource_group_name  = "rg-fabrykpoc1-core-kcl-eastus-002"
    storage_account_name = "logslinuxvm"
    container_name       = "logs"
    key                  = "vm.terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
