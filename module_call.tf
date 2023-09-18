/*
module "assmnt-vms" {
  source                  = "github.com/bsaneesh/tf-assessment-module"
  resource_group          = "tf-assessment-rg"
  location                = "South India"
  win-vm-name             = "tf-windows-vm"
  linux-vm-name           = "tf-linux-vm"
  vmsize                  = "Standard_B2s"
  username                = "admin-user"
  kv-id                   = "/subscriptions/b9315201-f5b4-4e8a-bba0-f716e23d0fae/resourceGroups/tf-assessment-rg/providers/Microsoft.KeyVault/vaults/tf-assessment-kv"
  nic-win                 = "/subscriptions/b9315201-f5b4-4e8a-bba0-f716e23d0fae/resourceGroups/tf-assessment-rg/providers/Microsoft.Network/networkInterfaces/tf-windows-nic"
  nic-lin                 = "/subscriptions/b9315201-f5b4-4e8a-bba0-f716e23d0fae/resourceGroups/tf-assessment-rg/providers/Microsoft.Network/networkInterfaces/tf-ubuntu-nic"
  win-custScript-name     = "CustomScript-IIS"
  lin-custScript-name     = "CustomScript-Nginx"
  win-custScript-fileuris = "https://tfassessmentstorage001.blob.core.windows.net/scripts/CustomScript-iis.ps1"
  lin-custScript-fileuris = "https://tfassessmentstorage001.blob.core.windows.net/scripts/CustomScript_Nginx.sh"
  Win-custScript-command  = "CustomScript-iis.ps1"
  lin-custScript-command  = "CustomScript_Nginx.sh"
}

*/