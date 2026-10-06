# Creates the storage account that holds the Terraform state of ../infra.
# Run once, with local state. This folder is the only one whose state
# stays on the local machine.

terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# The subscription comes from the ARM_SUBSCRIPTION_ID environment variable.
# Shared keys are disabled on the storage account, so the provider must use
# Entra ID to reach the storage data plane.
provider "azurerm" {
  features {}
  storage_use_azuread = true
}

data "azurerm_client_config" "current" {}

variable "location" {
  description = "Azure region for the state storage"
  type        = string
  default     = "spaincentral"
}

# Storage account names must be globally unique
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "state" {
  name     = "rg-tfstate"
  location = var.location

  tags = {
    project    = "azure-web-v2"
    managed_by = "terraform"
  }
}

resource "azurerm_storage_account" "state" {
  #checkov:skip=CKV_AZURE_59:Reached from the admin PC; access needs an Entra ID identity because shared keys are disabled
  #checkov:skip=CKV2_AZURE_33:A private endpoint would require a VPN or self-hosted runner, out of scope for this lab
  #checkov:skip=CKV2_AZURE_1:Platform-managed encryption is enough for a lab state file; CMK needs a Key Vault
  #checkov:skip=CKV_AZURE_33:The queue service is not used
  #checkov:skip=CKV_AZURE_206:ZRS keeps three copies across availability zones; geo-replication is not needed for a lab
  name                            = "sttfstate${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.state.name
  location                        = azurerm_resource_group.state.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  # No storage keys: Terraform authenticates with Entra ID (use_azuread_auth)
  shared_access_key_enabled = false

  sas_policy {
    expiration_period = "01.00:00:00"
  }

  # Every state change keeps the previous version, so a broken state can be restored
  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }

  tags = azurerm_resource_group.state.tags
}

resource "azurerm_storage_container" "state" {
  #checkov:skip=CKV2_AZURE_21:Blob read logging needs a Log Analytics workspace; versioning already keeps every state change
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

# Lets the signed-in user read and write the state with Entra ID
resource "azurerm_role_assignment" "state_access" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

output "backend_config" {
  description = "Contents for infra/backend.hcl"
  value       = <<-EOT
    resource_group_name  = "${azurerm_resource_group.state.name}"
    storage_account_name = "${azurerm_storage_account.state.name}"
    container_name       = "${azurerm_storage_container.state.name}"
    key                  = "azure-web-v2.tfstate"
    use_azuread_auth     = true
  EOT
}
