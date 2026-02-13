resource "azurerm_storage_account" "storageaccount" {
  name                     = "satfstate0209"
  resource_group_name      = azurerm_resource_group.resourcerg.name
  location                 = azurerm_resource_group.resourcerg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
    tags = {
        name        = "tf-SA"
        owner       = "mounica"
        environment = "Dev"
    }
  depends_on = [ azurerm_resource_group.resourcerg ]
}

