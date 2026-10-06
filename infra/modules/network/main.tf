resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.address_space]
  tags                = var.tags
}

# Private subnet: instances have no public IPs and no default outbound access.
# Outbound traffic (apt updates) goes through the load balancer outbound rule.
resource "azurerm_subnet" "web" {
  name                            = "snet-web"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = [cidrsubnet(var.address_space, 8, 1)]
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "web" {
  #checkov:skip=CKV_AZURE_160:Public website; HTTPS needs a domain and a certificate (see Next steps in the README)
  name                = "nsg-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTP-Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Bastion Developer connects from this Azure platform address.
  # SSH is never open to the internet.
  dynamic "security_rule" {
    for_each = var.enable_bastion ? [1] : []
    content {
      name                       = "Allow-SSH-Bastion"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "168.63.129.16"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

# Developer tier: free, no dedicated subnet or public IP, one session at a time
resource "azurerm_bastion_host" "this" {
  count               = var.enable_bastion ? 1 : 0
  name                = "bas-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Developer"
  virtual_network_id  = azurerm_virtual_network.this.id
  tags                = var.tags
}
