provider "azurerm" {
  features {}
}


data "azurerm_policy_set_definition" "example" {
  display_name = "Enable Azure Monitor for VMs"
}

data "azurerm_subscription" "current" {}

data "azurerm_log_analytics_workspace" "example" {
  name                = "logs"
  resource_group_name = "jenkins_group"
}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "Check Azure Monitor in VM"
  policy_definition_id = data.azurerm_policy_set_definition.example.id
  subscription_id      = data.azurerm_subscription.current.id
  location             = "eastus2"
  parameters           = jsonencode({
        "logAnalytics_1": {
        "value": data.azurerm_log_analytics_workspace.example.id,
        }
    })
  identity {
       type = "SystemAssigned" 
  }
}