variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "The Azure Client ID for authentication"
  type        = string
}

variable "client_secret" {
  description = "The Azure Client Secret for authentication"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
}

# Prefix for naming resources
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Location
variable "location" {
  description = "Azure region for resource group"
  type        = string
  default     = "East US"
}

# Node count for AKS cluster
variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

# VM size for the AKS nodes
variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

# Environment tag
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}
