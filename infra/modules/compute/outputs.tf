output "vmss_name" {
  description = "Name of the virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.web.name
}
