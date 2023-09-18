/*
resource "azurerm_virtual_network" "bastion-vnet" {
  name                = "tf-bastion-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.tf-assmnt-rg.location
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name
  depends_on          = [azurerm_resource_group.tf-assmnt-rg]
  tags                = local.tag
}

resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.tf-assmnt-rg.name
  virtual_network_name = azurerm_virtual_network.bastion-vnet.name
  address_prefixes     = ["172.16.0.0/27"]
  depends_on           = [azurerm_virtual_network.bastion-vnet]
}


resource "azurerm_public_ip" "bastion-pip" {
  name                = "tf-bastion-pip"
  location            = azurerm_resource_group.tf-assmnt-rg.location
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.tf-assmnt-rg]
  tags                = local.tag
}
*/


/*
resource "azurerm_bastion_host" "bastion-host" {
  name                = "tf-bastion-host"
  location            = azurerm_resource_group.tf-assmnt-rg.location
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
  sku = "Basic"
  depends_on = [azurerm_resource_group.tf-assmnt-rg,
    azurerm_public_ip.bastion-pip,
  azurerm_subnet.bastion-subnet]
  tags = local.tag
}
*/

/*
resource "azurerm_virtual_network_peering" "bastion-assessment" {
  name                      = "${azurerm_virtual_network.bastion-vnet.name}_${azurerm_virtual_network.tf-assmnt-vnet.name}"
  resource_group_name       = azurerm_resource_group.tf-assmnt-rg.name
  virtual_network_name      = azurerm_virtual_network.bastion-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.tf-assmnt-vnet.id
  depends_on = [azurerm_resource_group.tf-assmnt-rg,
    azurerm_virtual_network.bastion-vnet,
  azurerm_virtual_network.tf-assmnt-vnet]
}

resource "azurerm_virtual_network_peering" "assessment-bastion" {
  name                      = "${azurerm_virtual_network.tf-assmnt-vnet.name}_${azurerm_virtual_network.bastion-vnet.name}"
  resource_group_name       = azurerm_resource_group.tf-assmnt-rg.name
  virtual_network_name      = azurerm_virtual_network.tf-assmnt-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.bastion-vnet.id
  depends_on = [azurerm_resource_group.tf-assmnt-rg,
    azurerm_virtual_network.bastion-vnet,
  azurerm_virtual_network.tf-assmnt-vnet]
}
*/