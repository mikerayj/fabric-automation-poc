output "workspace_id" {
  description = "ID of the Fabric workspace."
  value       = fabric_workspace.this.id
}

output "workspace_name" {
  description = "Display name of the Fabric workspace."
  value       = fabric_workspace.this.display_name
}

output "workspace_description" {
  description = "Description of the Fabric workspace."
  value       = fabric_workspace.this.description
}

output "workspace_type" {
  description = "Type of the Fabric workspace."
  value       = fabric_workspace.this.type
}

output "capacity_id" {
  description = "ID of the capacity the workspace is assigned to."
  value       = fabric_workspace.this.capacity_id
}

output "capacity_region" {
  description = "Region of the capacity the workspace is assigned to."
  value       = fabric_workspace.this.capacity_region
}

output "capacity_assignment_progress" {
  description = "Progress status of the workspace capacity assignment."
  value       = fabric_workspace.this.capacity_assignment_progress
}

output "workspace_identity_type" {
  description = "Type of the workspace identity, or null when no identity was created."
  value       = try(fabric_workspace.this.identity.type, null)
}

output "workspace_identity_application_id" {
  description = "Application ID of the workspace identity, or null when no identity was created."
  value       = try(fabric_workspace.this.identity.application_id, null)
}

output "workspace_identity_service_principal_id" {
  description = "Service principal ID of the workspace identity, or null when no identity was created."
  value       = try(fabric_workspace.this.identity.service_principal_id, null)
}

output "onelake_dfs_endpoint" {
  description = "OneLake DFS (ADLS Gen2) endpoint of the workspace."
  value       = try(fabric_workspace.this.onelake_endpoints.dfs_endpoint, null)
}

output "onelake_blob_endpoint" {
  description = "OneLake Blob endpoint of the workspace."
  value       = try(fabric_workspace.this.onelake_endpoints.blob_endpoint, null)
}
