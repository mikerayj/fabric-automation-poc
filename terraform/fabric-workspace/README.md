# Fabric workspace Terraform

Terraform root module that manages the full lifecycle (create, update, destroy) of a
Microsoft Fabric workspace with the [`microsoft/fabric`](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace)
provider. The provider is Microsoft's partner-maintained provider and is the current
recommended way to manage Fabric workspaces as code.

The Fabric capacity is expected to already exist; its ID is an input.

## Inputs

| Variable | Default | Description |
| --- | --- | --- |
| `capacity_id` | *(required)* | ID of the existing Fabric capacity. |
| `workspace_name` | `""` | Explicit display name. Leave empty to generate an ephemeral name. |
| `workspace_name_prefix` | `fabric-ws` | Prefix used when `workspace_name` is empty. |
| `workspace_name_suffix` | `""` | Suffix used when `workspace_name` is empty. Empty means a random 6-character suffix. |
| `workspace_description` | `""` | Workspace description. |
| `enable_workspace_identity` | `true` | Create a system-assigned workspace identity. Set to `false` to create the workspace without a workspace identity. |
| `skip_capacity_state_validation` | `false` | Skip capacity state validation when the caller cannot list capacities. |
| `timeouts` | `{}` | Optional per-operation timeouts, for example `{ create = "30m" }`. |

## Outputs

`workspace_id`, `workspace_name`, `workspace_description`, `workspace_type`,
`capacity_id`, `capacity_region`, `capacity_assignment_progress`,
`workspace_identity_type`, `workspace_identity_application_id`,
`workspace_identity_service_principal_id`, `onelake_dfs_endpoint`,
`onelake_blob_endpoint`.

## Running locally

Authentication uses the Azure CLI by default, so no secrets belong in `.tf` files.

```bash
az login --tenant <tenant-id>

cd terraform/fabric-workspace
cp terraform.tfvars.example terraform.tfvars   # edit values

terraform init
terraform plan
terraform apply
terraform destroy
```

Service principal authentication is configured with environment variables
(`FABRIC_TENANT_ID`, `FABRIC_CLIENT_ID` and one of `FABRIC_CLIENT_SECRET`,
`FABRIC_USE_OIDC`, `FABRIC_USE_MSI`). See the
[provider authentication guides](https://registry.terraform.io/providers/microsoft/fabric/latest/docs).

### Ephemeral workspaces

Leave `workspace_name` empty to have a name generated:

```bash
terraform apply -var 'capacity_id=<capacity-id>' -var 'workspace_name_prefix=fabric-ws' -var 'workspace_name_suffix=alice-test'
```

With no suffix, a random one is generated and stored in state, so a later
`terraform destroy` removes the same workspace.

### Remote state

Local state is fine for a single engineer, but updates and teardowns from
automation need shared state. Rename `backend-azurerm.tf.example` to
`backend-azurerm.tf` and pass the storage details with `-backend-config`
(see the comments in that file). Use one state key per workspace.

## Running in GitHub Actions

- `.github/workflows/fabric-workspace-lifecycle.yml` is the dedicated lifecycle
  workflow. Run it with **Run workflow** and pick `plan`, `apply` or `destroy`.
- `.github/actions/fabric-workspace-terraform` is a composite action that can be
  reused from any other workflow:

```yaml
jobs:
  ephemeral-workspace:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@v4.2.2
      - id: workspace
        uses: ./.github/actions/fabric-workspace-terraform
        with:
          action: apply
          capacity-id: ${{ vars.FABRIC_CAPACITY_ID }}
          workspace-name-suffix: pr-${{ github.event.number }}
          tenant-id: ${{ secrets.FAB_TENANT_ID }}
          client-id: ${{ secrets.FAB_SPN_CLIENT_ID }}
          azure-subscription-id: ${{ vars.TF_STATE_SUBSCRIPTION_ID }}
          backend-config: |
            resource_group_name=${{ vars.TF_STATE_RESOURCE_GROUP }}
            storage_account_name=${{ vars.TF_STATE_STORAGE_ACCOUNT }}
            container_name=${{ vars.TF_STATE_CONTAINER }}
            key=fabric-workspace/pr-${{ github.event.number }}.tfstate
            use_azuread_auth=true
      - run: echo "Workspace ${{ steps.workspace.outputs.workspace-id }}"
```

The lifecycle workflow can also be called from another workflow:

```yaml
jobs:
  workspace:
    uses: ./.github/workflows/fabric-workspace-lifecycle.yml
    with:
      action: apply
      workspace_name: fabric-automation-poc-dev
    secrets: inherit
```

### Required GitHub configuration

| Name | Kind | Purpose |
| --- | --- | --- |
| `FAB_TENANT_ID` | secret | Entra tenant ID (already used by the deploy workflow). |
| `FAB_SPN_CLIENT_ID` | secret | Entra application used with GitHub workload identity federation. |
| `FABRIC_CAPACITY_ID` | variable | Default Fabric capacity ID. |
| `TF_STATE_RESOURCE_GROUP` | variable | Resource group of the state storage account. |
| `TF_STATE_STORAGE_ACCOUNT` | variable | State storage account name. |
| `TF_STATE_CONTAINER` | variable | State container name (defaults to `tfstate`). |
| `TF_STATE_SUBSCRIPTION_ID` | variable | Subscription of the state storage account. Required together with the other `TF_STATE_*` variables. |

The service principal needs the Fabric tenant setting *Service principals can use
Fabric APIs* enabled, contributor rights on the capacity, and `Storage Blob Data
Contributor` on the state container.
