# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group to contain all resources
resource "azurerm_resource_group" "rg" {
  name     = "stream_analytics_resources" # Name of the resource group
  location = var.location        # Location where the resource group will be created
}

# Create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name           # Name of the storage account
  resource_group_name      = azurerm_resource_group.rg.name     # Resource group in which the storage account will be created
  location                 = azurerm_resource_group.rg.location # Location of the storage account
  account_tier             = "Standard"                         # Performance tier of the storage account
  account_replication_type = "LRS"                              # Replication type of the storage account
  access_tier              = "Hot"                              # Access tier for the storage account
  enable_https_traffic_only = true                              # Enforce HTTPS for accessing storage account
  is_hns_enabled           = true                               # Enable hierarchical namespace (Azure Data Lake Storage Gen2)

  tags = {
    DeploymentId = var.unique_suffix # Tag to make resources unique
  }
}

# Create a storage container within the storage account
resource "azurerm_storage_container" "container" {
  name                  = var.container_name                   # Name of the container
  storage_account_name  = azurerm_storage_account.storage.name # Storage account in which the container will be created
  container_access_type = "private"                            # Access level of the container
}

# Create an Event Hubs namespace
resource "azurerm_eventhub_namespace" "namespace" {
  name                = var.event_ns_name                      # Name of the Event Hubs namespace
  location            = azurerm_resource_group.rg.location     # Location of the Event Hubs namespace
  resource_group_name = azurerm_resource_group.rg.name         # Resource group in which the namespace will be created
  sku                 = "Standard"                             # Pricing tier of the Event Hubs namespace
  capacity            = 1                                      # Capacity of the Event Hubs namespace

  tags = {
    DeploymentId = var.unique_suffix # Tag to make resources unique
  }
}

# Create an authorization rule for the Event Hubs namespace
resource "azurerm_eventhub_namespace_authorization_rule" "auth_rule" {
  name                = "RootManageSharedAccessKey"            # Name of the authorization rule
  namespace_name      = azurerm_eventhub_namespace.namespace.name # Namespace to which the rule applies
  resource_group_name = azurerm_resource_group.rg.name         # Resource group in which the namespace is located
  listen              = true                                   # Enable listen permission
  send                = true                                   # Enable send permission
  manage              = true                                   # Enable manage permission
}

# Create an Event Hub within the namespace
resource "azurerm_eventhub" "eventhub" {
  name                = var.event_hub_name                     # Name of the Event Hub
  namespace_name      = azurerm_eventhub_namespace.namespace.name # Namespace in which the Event Hub will be created
  resource_group_name = azurerm_resource_group.rg.name         # Resource group in which the namespace is located
  partition_count     = 2                                      # Number of partitions in the Event Hub
  message_retention   = 1                                      # Number of days to retain messages in the Event Hub
}

# Create a default consumer group for the Event Hub
resource "azurerm_eventhub_consumer_group" "consumer_group" {
  name                = var.consumer_group_name                        # Name of the consumer group
  namespace_name      = azurerm_eventhub_namespace.namespace.name # Namespace in which the consumer group will be created
  eventhub_name       = azurerm_eventhub.eventhub.name         # Event Hub to which the consumer group will belong
  resource_group_name = azurerm_resource_group.rg.name         # Resource group in which the namespace is located
}