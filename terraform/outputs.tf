output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "eventhub_namespace_id" {
  value = azurerm_eventhub_namespace.namespace.id
}

output "eventhub_id" {
  value = azurerm_eventhub.eventhub.id
}