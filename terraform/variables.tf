variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The location of the resources."
}

variable "stream_analytics_job_name" {
  type        = string
  description = "The name of the Stream Analytics job."
}

variable "eventhub_namespace" {
  type        = string
  description = "The namespace of the Event Hub."
}

variable "eventhub_name" {
  type        = string
  description = "The name of the Event Hub."
}

variable "eventhub_key" {
  type        = string
  description = "The shared access policy key for the Event Hub."
  sensitive   = true
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
}

variable "storage_container" {
  type        = string
  description = "The name of the storage container."
}

variable "storage_path_prefix" {
  type        = string
  description = "The path prefix for the blob storage."
}

variable "query" {
  type        = string
  description = "The query for the Stream Analytics job."
}