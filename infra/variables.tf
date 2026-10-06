variable "name" {
  description = "Short name used in every resource name"
  type        = string
  default     = "webv2"
}

variable "location" {
  description = "Azure region (the student subscription only allows a few European regions)"
  type        = string
  default     = "spaincentral"
}

variable "address_space" {
  description = "VNet address space"
  type        = string
  default     = "172.16.0.0/16"
}

variable "zones" {
  description = "Availability zones for the instances (the B-series is only offered in zones 2 and 3 of Spain Central for this subscription)"
  type        = list(string)
  default     = ["2", "3"]

  validation {
    condition     = length(var.zones) >= 2
    error_message = "Use at least 2 availability zones for high availability."
  }
}

variable "vm_size" {
  description = "Size of each web instance"
  type        = string
  default     = "Standard_B2ats_v2"
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
