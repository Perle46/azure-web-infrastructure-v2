variable "name" {
  description = "Name suffix for the network resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the network resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "VNet address space; the web subnet is the second /24 inside it"
  type        = string
}

variable "enable_bastion" {
  description = "Create a Bastion Developer host and allow SSH from it"
  type        = bool
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}
