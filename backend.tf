terraform {
  backend "azurerm" {
    resource_group_name  = "newpsrg"
    storage_account_name = "storageforpstest"
    container_name       = "tfstate"
    key                  = "tf-assessment.tfstate"
  }
}