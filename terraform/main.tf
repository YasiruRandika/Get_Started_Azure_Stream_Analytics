provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_stream_analytics_job" "sa" {
  name                = var.stream_analytics_job_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  transformation_query = file("${path.module}/queries/query.sql")
  streaming_units      = 1

  depends_on = [
    azurerm_eventhub_namespace.eh
  ]
}