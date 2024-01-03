output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_stress_ip" {
  value = azurerm_linux_virtual_machine.stress.public_ip_address
}

output "vm_b_ip" {
  value = azurerm_linux_virtual_machine.mon.public_ip_address
}