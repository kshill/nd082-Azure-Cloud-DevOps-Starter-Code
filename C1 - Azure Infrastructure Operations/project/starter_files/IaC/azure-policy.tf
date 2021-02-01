resource "azurerm_policy_definition" "taggingPolicy" {
  name         = "tagging-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "tagging-policy"

  metadata = <<METADATA
    {
    "category": "Tags"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf":  [
            {
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "exists": "false"
            }
        ]
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "tagName": {
      "type": "String",
      "metadata": {
        "displayName": "Name Of Tag",
        "description": "Tag Name Must Be Specified"
      }
    }
  }
PARAMETERS

}

resource "azurerm_policy_assignment" "auditTaggingInSubscription" {
    name = "tagging-policy-assignment"
    scope = "${var.cust_scope}${var.subscriptionid}"
    policy_definition_id = azurerm_policy_definition.taggingPolicy.id
    description = "Denies the creation of resources that do not have a tag."
    display_name = "Deny Resource Creation That Do Not Have Tags"

    metadata = <<METADATA
    {
    "category": "Tags"
    }
METADATA

  parameters = <<PARAMETERS
{
  "tagName": {
    "value": "Environment"
  }
}
PARAMETERS
}