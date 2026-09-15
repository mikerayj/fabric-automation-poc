# fabric-automation-poc

Sample repo to demonstrate a Hello World-style Microsoft Fabric deployment layout and the GitHub automation that can validate it.

## Repository layout

```text
fabric/
  HelloWorld.Notebook/
    .platform
    notebook-content.py
terraform/
  fabric-workspace/
.github/actions/
  fabric-workspace-terraform/
.github/workflows/
  validate-fabric-layout.yml
  fabric-workspace-lifecycle.yml
```

- `fabric/HelloWorld.Notebook` is a minimal Fabric notebook item that can be used as the first asset in a Fabric workspace connected to this repository.
- `.github/workflows/validate-fabric-layout.yml` checks that Fabric item folders include required metadata and that the Hello World notebook source is present.
- `terraform/fabric-workspace` provisions, updates and tears down a Fabric workspace with the `microsoft/fabric` Terraform provider. See its [README](terraform/fabric-workspace/README.md).
- `.github/workflows/fabric-workspace-lifecycle.yml` runs that Terraform (`plan`, `apply`, `destroy`) and can be called from other workflows; `.github/actions/fabric-workspace-terraform` is the reusable composite action behind it.

The `logicalId` in `fabric/HelloWorld.Notebook/.platform` is a placeholder for this sample. Fabric Git integration may regenerate or remap item identifiers when the workspace is first synchronized.

## Getting started

1. Create or choose a Microsoft Fabric workspace, either manually or with `terraform/fabric-workspace`.
2. Connect the workspace to this repository using Fabric Git integration.
3. Sync the `fabric/` folder into the workspace.
4. Open the `HelloWorld` notebook and run it to print a sample message.

Future automation can build on the validation workflow by adding authenticated deployment steps once the target workspace and credentials are available.
