# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "monitor-${local.env}-${local.loc}-rg-01"
  location = local.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "monitor-${local.env}-${local.loc}-vnet-01"
  address_space       = local.vnet_addressprefixes
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create Subnet
resource "azurerm_subnet" "example" {
  name                 = "monitor-${local.env}-${local.loc}-snet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = local.subnet_main_addressprefixes
}


##------------------------##
##          VM 1          ##
##------------------------##

# Create public IPs
resource "azurerm_public_ip" "stress_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Interface 
resource "azurerm_network_interface" "stressnic" {
  name                = "estress-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.stress_public_ip.id
  }
}

# Create Network Security Group and Rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "prometheus-rule"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefixes    = local.subnet_main_addressprefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "grafana-rule"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefixes    = local.subnet_main_addressprefixes
    destination_address_prefix = "*"

  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example1" {
  network_interface_id      = azurerm_network_interface.stressnic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "stress" {
  name                = "monitor-${local.env}-${local.loc}-vm-stress"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.stressnic.id,
  ]

  admin_ssh_key {
    username = "adminuser"
    #public_key = file("~/.ssh/id_rsa.pub")
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

##------------------------##
##          VM 2          ##
##------------------------##

# Create public IPs
resource "azurerm_public_ip" "mon_public_ip" {
  name                = "myPublicIP2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Interface 
resource "azurerm_network_interface" "monnic" {
  name                = "mon-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal2"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mon_public_ip.id
  }
}

# Create Network Security Group and Rule
resource "azurerm_network_security_group" "mon_terraform_nsg" {
  name                = "myNetworkSecurityGroup2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example2" {
  network_interface_id      = azurerm_network_interface.monnic.id
  network_security_group_id = azurerm_network_security_group.mon_terraform_nsg.id
}

resource "tls_private_key" "mon_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "mon" {
  name                = "monitor-${local.env}-${local.loc}-vm-mon"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.monnic.id,
  ]

  admin_ssh_key {
    username = "adminuser"
    #public_key = file("~/.ssh/id_rsa.pub")
    public_key = tls_private_key.mon_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}