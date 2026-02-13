resource "azurerm_resource_group" "rg" {
  name     = "rg-vm"
  location = var.location
}
resource "azurerm_storage_account" "sa" {
  name                     = "sametavm19098"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-meta"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-meta"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-meta"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "allow_ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "pip-meta-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-meta-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig-meta-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
  # network_security_group_id = azurer_network_security_group.nsg.id
}
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "vm-meta-0${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  os_disk {
    name                 = "osdisk-meta-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }
  disable_password_authentication = true
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" # Verify the correct offer for Ubuntu 24.04 LTS
    sku       = "server"
    version   = "latest"
  }
}


