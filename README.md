# Azure Policy
## Usage

```terraform

locals {

  policy_tags_rule = <<RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Compute/virtualMachineScaleSets"
      },
      {
        "not": {
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "equals": "[parameters('tagValue')]"
        }
      }
    ]
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
      ],
      "operations": [
        {
          "operation": "addOrReplace",
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "value": "[parameters('tagValue')]"
        }
      ]
    }
  }
}
RULE

  policy_tags_parameters = <<PARAMETERS
{
  "tagName": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Name",
      "description": "Name of the tag, such as 'environment'"
    }
  },
  "tagValue": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Value",
      "description": "Value of the tag, such as 'production'"
    }
  }
}
PARAMETERS

  policy_assignments = {
    production = {
      display_name = "VMSS tags checking for my production subscription"
      description  = "VMSS tags checking for my production subscription"
      scope        = "/subscriptions/xxxxx",
      location     = module.azure_region.location
      parameters = jsonencode({
        environment = {
          value = "production"
        },
        managed_by = {
          value = "devops"
        }
      })
      identity_type = "SystemAssigned"
    },
    preproduction = {
      display_name = "VMSS tags checking for my preproduction subscription"
      description  = "VMSS tags checking for my preproduction subscription"
      scope        = "/subscriptions/xxxxx",
      location     = module.azure_region.location
      parameters = jsonencode({
        env = {
          value = "preproduction"
        },
        managed_by = {
          value = "devops"
        }
      })
      identity_type = "None"
    }
  }
}

module "policy_tags" {
  source  = "./policy"

  policy_display_name       = "VMSS tagging policy"

  policy_rule_content       = local.policy_tags_rule
  policy_parameters_content = local.policy_tags_parameters

  policy_assignments        = local.policy_assignments
}


```


azurerm_policy_definition: Manages a policy rule definition on a management group or your provider subscription. Policy definitions do not take effect until they are assigned to a scope using a Policy Assignment.

azurerm_policy_set_definition:  Policy set definitions (also known as policy initiatives).
