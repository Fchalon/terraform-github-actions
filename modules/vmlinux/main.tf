# The resource group ,virtual network and subnet are defined
data "azurerm_resource_group" "rg" {
  name = "rg-fabrykpoc1-core-kcl-eastus-002"
}

data "azurerm_virtual_network" "tf_net" {
  name                = "vnet-rg-fabrykpoc1-core-kcl-eastus-002"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "tf_subnet" {
  name                 = "application"
  virtual_network_name = data.azurerm_virtual_network.tf_net.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_ssh_public_key" "key" {
  name                = "FRADO"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "networknic" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags = {
    ApplicationId = "MJIL-Sandbox"
    accountid     = "M.242TP"
    practice      = "cloud"
    teamorproject = "FABRYK"
  }

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = data.azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.hostname}-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.networknic.id,
  ]

  tags = {
    ApplicationId = "MJIL-Sandbox"
    accountid     = "M.242TP"
    practice      = "cloud"
    teamorproject = "FABRYK"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_ssh_public_key.key.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

