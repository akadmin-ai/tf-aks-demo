# Configure the Azure provider
provider "azurerm" {
  features {}

  # Use variables for provider authentication details
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Data block to use an existing resource group
data "azurerm_resource_group" "existing_rg" {
  name     = var.resource_group_name
}

# AKS cluster, using the existing resource group
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.prefix}-aks"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

# Assign AKS identity (managed identity) the ACR Pull role for GHCR access
resource "azurerm_role_assignment" "aks_to_ghcr" {
  principal_id       = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
  role_definition_name = "AcrPull"  # This role allows AKS to pull from the container registry
  scope               = "/subscriptions/${var.subscription_id}"  # Scope to the GHCR repository
}

# Output the AKS cluster name
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

