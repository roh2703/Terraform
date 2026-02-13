# Terraform Settings Block
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0" # Optional but recommended in production
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "baaed663-22f5-44f5-9d8b-8f2711bd3a06" # Add your actual subscription ID here
}
# # Create Resource Group
# resource "azurerm_resource_group" "my_demo_rg6" {
#   location = "eastus"
#   name     = "rg-dev-plan-01"
#   tags = {
#     name        = "rg-dev"
#     owner       = "mounica"
#     environment = "Dev"
#   }
# }

# Create Azure Storage Account
resource "azurerm_storage_account" "stdevplan01" {
  name                     = "stdevplan01"
  resource_group_name      = azurerm_resource_group.my_demo_rg6.name
  location                 = azurerm_resource_group.my_demo_rg6.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
    tags = {
        name        = "stdevplan01"
        owner       = "mounica"
        environment = "Dev"
    }

}

# # Create Virtual Network
# resource "azurerm_virtual_network" "vnet_dev_plan_01" {
#   name                = "vnet-dev-plan-01"
#   location            = azurerm_resource_group.my_demo_rg6.location
#   resource_group_name = azurerm_resource_group.my_demo_rg6.name

#   address_space = ["10.0.0.0/16"]

#   tags = {
#     name        = "vnet-dev"
#     owner       = "mounica"
#     environment = "Dev"
#   }
# }

# # Create Virtual Network Subnet
# resource "azurerm_subnet" "subnet_dev_priv_plan_01" {
#   name                 = "subnet-dev-plan-01"
#   resource_group_name  = azurerm_resource_group.my_demo_rg6.name
#   virtual_network_name = azurerm_virtual_network.vnet_dev_plan_01.name
#   address_prefixes     = ["10.0.1.0/24"]
# }
# resource "azurerm_subnet" "subnet_dev_pub_plan_01" {
#   name                 = "subnet-dev-pub-plan-01"
#   resource_group_name  = azurerm_resource_group.my_demo_rg6.name
#   virtual_network_name = azurerm_virtual_network.vnet_dev_plan_01.name
#   address_prefixes     = ["10.0.2.0/24"]
# } 


