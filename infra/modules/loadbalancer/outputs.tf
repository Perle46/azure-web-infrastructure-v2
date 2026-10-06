output "public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.this.ip_address
}

output "backend_pool_id" {
  description = "ID of the backend pool for the web instances"
  value       = azurerm_lb_backend_address_pool.web.id
}

output "health_probe_id" {
  description = "ID of the HTTP health probe"
  value       = azurerm_lb_probe.http.id
}
