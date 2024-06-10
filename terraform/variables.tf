variable "storage_account_name" {
  type        = string
  description = "Azure storage account name."
}

variable "unique_suffix" {
  type        = string
  description = "Suffix added to all resource name to make them unique."
}

variable "event_ns_name" {
  type        = string
  description = "EventHubs namespace name."
}

variable "event_hub_name" {
  type        = string
  description = "EventHub name."
}

variable "location" {
  type        = string
  description = "The location of the resources."
  default     = "East US" # Set your default location or customize as needed
}

variable "container_name" {
  type        = string
  description = "The name of the storage container."
  default     = "data"
}