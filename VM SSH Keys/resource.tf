resource "azurerm_resource_group" "rg" {
  for_each = var.environments
  name     = "rg-${each.key}"
  location = var.location

}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.environments
  name                = "vnet-${each.key}"
  address_space       = ["10.${each.key == "dev" ? "1" : each.key == "qa" ? "2" : "3"}.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.key].name

}
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.environments
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.key].name

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


resource "azurerm_subnet" "subnet" {
  for_each             = var.environments
  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.${each.key == "dev" ? "1" : each.key == "qa" ? "2" : "3"}.1.0/24"]

}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  for_each = var.environments
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.environments
  name                = "pip-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.environments
  name                = "nic-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  ip_configuration {
    name                          = "ipconfig-${each.key}"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.environments
  name                = "vm-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  size                = each.value
  admin_username      = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  os_disk {
    name                 = "osdisk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" # Verify the correct offer for Ubuntu 24.04 LTS
    sku       = "server"
    version   = "latest"
  }


}