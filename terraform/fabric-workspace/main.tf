locals {
  needs_random_suffix = var.workspace_name == "" && var.workspace_name_suffix == ""
  generated_suffix    = local.needs_random_suffix ? one(random_string.suffix[*].result) : var.workspace_name_suffix
  workspace_name      = var.workspace_name != "" ? var.workspace_name : "${var.workspace_name_prefix}-${local.generated_suffix}"
}

# Only used when neither an explicit name nor a suffix is supplied, so an
# engineer can stand up an ephemeral workspace without inventing a unique name.
# The suffix is kept in state so later updates and destroys target the same
# workspace.
resource "random_string" "suffix" {
  count = local.needs_random_suffix ? 1 : 0

  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "fabric_workspace" "this" {
  display_name                   = local.workspace_name
  description                    = var.workspace_description
  capacity_id                    = var.capacity_id
  skip_capacity_state_validation = var.skip_capacity_state_validation

  identity = var.enable_workspace_identity ? { type = "SystemAssigned" } : null

  timeouts = var.timeouts

  lifecycle {
    precondition {
      condition     = length(local.workspace_name) <= 256
      error_message = "The resulting workspace name must be at most 256 characters; shorten workspace_name_prefix or workspace_name_suffix."
    }
  }
}
