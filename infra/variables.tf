variable "name" {
  description = "Short name used in every resource name"
  type        = string
  default     = "webv2"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "francecentral"
}

variable "address_space" {
  description = "VNet address space"
  type        = string
  default     = "172.16.0.0/16"
}

variable "zones" {
  description = "Availability zones for the instances and the public IP"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "vm_size" {
  description = "Size of each web instance"
  type        = string
  default     = "Standard_B2ts_v2"
}

variable "min_instances" {
  description = "Minimum (and initial) number of web instances"
  type        = number
  default     = 2

  validation {
    condition     = var.min_instances >= 2
    error_message = "At least 2 instances are needed for high availability."
  }
}

variable "max_instances" {
  description = "Maximum number of web instances (mind the vCPU quota of the subscription)"
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "Admin user on the instances"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for the admin user (contents of the .pub file)"
  type        = string
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion (Developer tier) for SSH access to the instances"
  type        = bool
  default     = false
}
