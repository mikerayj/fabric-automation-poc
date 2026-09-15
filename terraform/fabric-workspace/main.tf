locals {
  needs_random_suffix = var.workspace_name == "" && var.workspace_name_suffix == ""
  generated_suffix    = local.needs_random_suffix ? one(random_string.suffix[*].result) : var.workspace_name_suffix
  workspace_name      = var.workspace_name != "" ? var.workspace_name : "${var.workspace_name_prefix}-${local.generated_suffix}"
}

# Only used when neither an explicit name nor a suffix is supplied, so an
# engineer can stand up an ephemeral workspace without inventing a unique name.
resource "random_string" "suffix" {
  count = local.needs_random_suffix ? 1 : 0

  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false

  keepers = {
    prefix = var.workspace_name_prefix
  }
}

resource "fabric_workspace" "this" {
  display_name                   = local.workspace_name
  description                    = var.workspace_description
  capacity_id                    = var.capacity_id
  skip_capacity_state_validation = var.skip_capacity_state_validation

  identity = var.enable_workspace_identity ? { type = "SystemAssigned" } : null

  timeouts = var.timeouts
}
