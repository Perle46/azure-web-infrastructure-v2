terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote state in Azure Storage (created by ../bootstrap).
  # Values are passed with: terraform init -backend-config=backend.hcl
  backend "azurerm" {}
}

# The subscription comes from the ARM_SUBSCRIPTION_ID environment variable
provider "azurerm" {
  features {}
}
