output "storage_account_id" {
  value = azurerm_storage_account.example.id
}

output "eventhub_namespace_id" {
  value = azurerm_eventhub_namespace.example.id
}

output "eventhub_id" {
  value = azurerm_eventhub.example.id
}