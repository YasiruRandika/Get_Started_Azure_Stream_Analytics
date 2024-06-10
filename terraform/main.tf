provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  enable_https_traffic_only = true
  is_hns_enabled           = true

  tags = {
    DeploymentId = var.unique_suffix
  }
}

resource "azurerm_storage_container" "example" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = var.event_ns_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    DeploymentId = var.unique_suffix
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "example" {
  name                = "RootManageSharedAccessKey"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  listen              = true
  send                = true
  manage              = true
}

resource "azurerm_eventhub" "example" {
  name                = var.event_hub_name
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "example" {
  name                = "$Default"
  namespace_name      = azurerm_eventhub_namespace.example.name
  eventhub_name       = azurerm_eventhub.example.name
  resource_group_name = azurerm_resource_group.example.name
}