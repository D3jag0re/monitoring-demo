output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_stress_ip" {
  value = azurerm_linux_virtual_machine.stress.public_ip_address
}


output "vm_mon_ip" {
  value = azurerm_linux_virtual_machine.mon.public_ip_address
}

## Below is for testing only ## 

output "gimmie_key_stress" {
  value = tls_private_key.example_ssh.public_key_openssh
  description = "Private Key in PEM format"
  sensitive = true
}

output "gimmie_key_mon" {
  value = tls_private_key.example_ssh.public_key_openssh
  description = "Private Key in PEM format"
  sensitive = true
}