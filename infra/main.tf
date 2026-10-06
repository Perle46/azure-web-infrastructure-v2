locals {
  tags = {
    project    = "azure-web-v2"
    managed_by = "terraform"
  }
}

# The region is part of the name so that moving to another region never
# reuses the ID of a resource group that Azure is still deleting
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${var.location}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "./modules/network"

  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  enable_bastion      = var.enable_bastion
  tags                = local.tags
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.tags
}

module "compute" {
  source = "./modules/compute"

  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  vm_size             = var.vm_size
  min_instances       = var.min_instances
  max_instances       = var.max_instances
  zones               = var.zones
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  cloud_init          = file("${path.module}/cloud-init.yaml")
  subnet_id           = module.network.subnet_id
  backend_pool_id     = module.loadbalancer.backend_pool_id
  health_probe_id     = module.loadbalancer.health_probe_id
  tags                = local.tags

  # A rolling-upgrade scale set needs its probe to be in use by a load
  # balancing rule before it is created
  depends_on = [module.loadbalancer]
}
