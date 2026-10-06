output "website_url" {
  description = "Public URL of the website"
  value       = "http://${module.loadbalancer.public_ip}"
}

output "resource_group" {
  description = "Resource group with all the resources"
  value       = azurerm_resource_group.this.name
}

output "vmss_name" {
  description = "Name of the virtual machine scale set"
  value       = module.compute.vmss_name
}
