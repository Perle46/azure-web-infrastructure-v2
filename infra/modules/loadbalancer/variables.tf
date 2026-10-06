variable "name" {
  description = "Name suffix for the load balancer resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the load balancer resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "zones" {
  description = "Availability zones for the public IP"
  type        = list(string)
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}
