# Create Resource Group
resource "azurerm_resource_group" "resourcerg" {
  
  name     = "rg-storage-backup-01"
  location = "eastus"
  tags = {
    name        = "rg-storage-backup"
    owner       = "mounica"
    environment = "Dev"
  }
}