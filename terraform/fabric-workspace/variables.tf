variable "capacity_id" {
  description = "ID of the existing Fabric capacity the workspace is assigned to."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.capacity_id))
    error_message = "capacity_id must be a GUID, for example 00000000-0000-0000-0000-000000000000."
  }
}

variable "workspace_name" {
  description = "Explicit workspace display name. Leave empty to generate an ephemeral name from workspace_name_prefix and workspace_name_suffix."
  type        = string
  default     = ""

  validation {
    condition     = length(var.workspace_name) <= 256
    error_message = "workspace_name must be at most 256 characters."
  }
}

variable "workspace_name_prefix" {
  description = "Prefix used when workspace_name is empty and the name is generated."
  type        = string
  default     = "fabric-ws"

  validation {
    condition     = length(var.workspace_name_prefix) > 0 && length(var.workspace_name_prefix) <= 200
    error_message = "workspace_name_prefix must be between 1 and 200 characters."
  }
}

variable "workspace_name_suffix" {
  description = "Suffix used when workspace_name is empty, for example a GitHub run ID or branch name. Leave empty to generate a random suffix."
  type        = string
  default     = ""

  validation {
    condition     = length(var.workspace_name_suffix) <= 50
    error_message = "workspace_name_suffix must be at most 50 characters."
  }
}

variable "workspace_description" {
  description = "Workspace description."
  type        = string
  default     = ""

  validation {
    condition     = length(var.workspace_description) <= 4000
    error_message = "workspace_description must be at most 4000 characters."
  }
}

variable "enable_workspace_identity" {
  description = "Create a system-assigned workspace identity. Set to false to override."
  type        = bool
  default     = true
}

variable "skip_capacity_state_validation" {
  description = "Skip validation of the capacity state. Use when the caller cannot list capacities."
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Optional operation timeouts, for example { create = \"30m\" }."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}
