variable "name" {
  description = "Name suffix for the compute resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the compute resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vm_size" {
  description = "Size of each instance"
  type        = string
}

variable "min_instances" {
  description = "Minimum (and initial) number of instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances the autoscale rule can reach"
  type        = number
}

variable "zones" {
  description = "Availability zones the instances are spread across"
  type        = list(string)
}

variable "admin_username" {
  description = "Admin user on the instances"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for the admin user"
  type        = string
}

variable "cloud_init" {
  description = "cloud-init configuration (plain text)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet for the instances"
  type        = string
}

variable "backend_pool_id" {
  description = "Load balancer backend pool the instances join"
  type        = string
}

variable "health_probe_id" {
  description = "Load balancer probe used for rolling upgrades and instance repair"
  type        = string
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}
