resource "azurerm_resource_group" "tf-assmnt-rg" {
  name     = var.resource_group
  location = var.location
  tags     = local.tag
}


# Vnet and Sunets
resource "azurerm_virtual_network" "tf-assmnt-vnet" {
  name                = var.vnetname
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name
  location            = azurerm_resource_group.tf-assmnt-rg.location
  address_space       = [var.vnetaddress]
  depends_on          = [azurerm_resource_group.tf-assmnt-rg]
  tags                = local.tag
}

resource "azurerm_subnet" "tf-assmnt-subnets" {
  for_each             = var.subnetnames
  name                 = each.key
  resource_group_name  = azurerm_resource_group.tf-assmnt-rg.name
  virtual_network_name = azurerm_virtual_network.tf-assmnt-vnet.name
  address_prefixes     = [cidrsubnet(var.vnetaddress, 8, index(tolist(var.subnetnames), each.key))]
  depends_on           = [azurerm_virtual_network.tf-assmnt-vnet]
}

# Nic cards

resource "azurerm_network_interface" "assment-nics" {
  count               = length(var.nics)
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name
  name                = "tf-${var.nics[count.index]}-nic"
  location            = azurerm_resource_group.tf-assmnt-rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-assmnt-subnets["subnet${count.index + 1}"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.tf-assmnt-subnets["subnet${count.index + 1}"].address_prefixes[0], "${count.index + 4}")
  }
  depends_on = [azurerm_resource_group.tf-assmnt-rg, azurerm_subnet.tf-assmnt-subnets]
}

# NSG association with IB port 80.

resource "azurerm_network_security_group" "assessment-nsg" {
  name                = var.nsgname
  location            = azurerm_resource_group.tf-assmnt-rg.location
  resource_group_name = azurerm_resource_group.tf-assmnt-rg.name

  security_rule {
    name                       = "Allow-80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_resource_group.tf-assmnt-rg]
}

resource "azurerm_subnet_network_security_group_association" "assmnt-nsg-assoctn" {
  for_each                  = var.subnetnames
  subnet_id                 = azurerm_subnet.tf-assmnt-subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.assessment-nsg.id
  depends_on                = [azurerm_subnet.tf-assmnt-subnets]
}


# Creating Storage Account and placing custom scripts in container

resource "azurerm_storage_account" "tf-assessment-storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.tf-assmnt-rg.name
  location                 = azurerm_resource_group.tf-assmnt-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.tf-assmnt-rg]
}

resource "azurerm_storage_container" "tf-assessment-container" {
  name                  = var.container_name
  storage_account_name  = var.storage_name
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.tf-assessment-storage]
}

resource "azurerm_storage_blob" "customscript" {
  count                  = length(var.blobs)
  name                   = var.blobs[count.index]
  storage_account_name   = var.storage_name
  storage_container_name = var.container_name
  type                   = "Block"
  source                 = "${path.module}/${var.blobs[count.index]}"
  depends_on             = [azurerm_storage_container.tf-assessment-container]

}


# Creating Keyvault for storing secrets.

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "assmnt-kv" {
  name                       = var.Keyvault
  location                   = azurerm_resource_group.tf-assmnt-rg.location
  resource_group_name        = azurerm_resource_group.tf-assmnt-rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id



    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Purge"
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [azurerm_resource_group.tf-assmnt-rg]

  lifecycle {
    ignore_changes = [access_policy]
  }
}


resource "azurerm_key_vault_access_policy" "kv-access-policy-self" {
  key_vault_id = azurerm_key_vault.assmnt-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.access-objectid

  secret_permissions = [
    "Get", "List", "Set"
  ]
  depends_on = [azurerm_key_vault.assmnt-kv]
}

resource "azurerm_key_vault_secret" "assmnt-kv-secret" {
  name         = var.kv-secret-name
  value        = var.kv-secret-password
  key_vault_id = azurerm_key_vault.assmnt-kv.id
  depends_on   = [azurerm_key_vault.assmnt-kv]
}

/*
data "azurerm_key_vault_secret" "secret-in-kv" {
  name         = "vm-password"
  key_vault_id = azurerm_key_vault.assmnt-kv.id
}
*/


# Load Balancer

resource "azurerm_public_ip" "assmnt-lb-pip" {
  name                = var.lb-pip
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.tf-assmnt-rg]
}

resource "azurerm_lb" "assmnt-lb" {
  name                = var.lb-name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.lb-fe
    public_ip_address_id = azurerm_public_ip.assmnt-lb-pip.id
  }
  depends_on = [azurerm_resource_group.tf-assmnt-rg, azurerm_public_ip.assmnt-lb-pip]
}

resource "azurerm_lb_backend_address_pool" "assmnt-lb-be" {
  loadbalancer_id = azurerm_lb.assmnt-lb.id
  name            = var.lb-be
  depends_on      = [azurerm_lb.assmnt-lb]
}

resource "azurerm_lb_backend_address_pool_address" "assmnt-lb-bepool" {
  count                   = length(var.nics)
  name                    = "${var.bepool-nameprefix}-${var.nics[count.index]}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.assmnt-lb-be.id
  virtual_network_id      = azurerm_virtual_network.tf-assmnt-vnet.id
  ip_address              = azurerm_network_interface.assment-nics[count.index].private_ip_address
  depends_on              = [azurerm_lb_backend_address_pool.assmnt-lb-be]
}

resource "azurerm_lb_probe" "assment-lb-hp" {
  loadbalancer_id = azurerm_lb.assmnt-lb.id
  name            = var.lb-hp
  port            = 80
  protocol        = "Tcp"
  depends_on      = [azurerm_lb.assmnt-lb]
}

resource "azurerm_lb_rule" "assmnt-lb-rule" {
  loadbalancer_id                = azurerm_lb.assmnt-lb.id
  name                           = var.lb-rule
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.assmnt-lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.assment-lb-hp.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.assmnt-lb-be.id]
  depends_on                     = [azurerm_lb_backend_address_pool_address.assmnt-lb-bepool, azurerm_lb_probe.assment-lb-hp]
}
