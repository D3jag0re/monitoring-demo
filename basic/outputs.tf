output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Public IPs

output "vm_stress_ip" {
  value = azurerm_linux_virtual_machine.stress.public_ip_address
}

output "vm_mon_ip" {
  value = azurerm_linux_virtual_machine.mon.public_ip_address
}



# Private IPs

output "vm_stress_ip_priv" {
  value = azurerm_linux_virtual_machine.stress.private_ip_address
}

output "vm_mon_ip_priv" {
  value = azurerm_linux_virtual_machine.mon.private_ip_address
}

## Below is for testing only, this is not recommended for security reasons ## 

output "gimmie_key_stress" {
  value       = tls_private_key.example_ssh.public_key_openssh
  description = "Private Key in PEM format"
  sensitive   = true
}

output "gimmie_key_stress_priv" {
  value       = tls_private_key.example_ssh.private_key_pem
  description = "Private Key in PEM format"
  sensitive   = true
}

output "gimmie_key_mon" {
  value       = tls_private_key.mon_ssh.public_key_openssh
  description = "Private Key in PEM format"
  sensitive   = true
}

output "gimmie_key_mon_priv" {
  value       = tls_private_key.mon_ssh.private_key_pem
  description = "Private Key in PEM format"
  sensitive   = true
}