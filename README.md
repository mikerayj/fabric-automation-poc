# fabric-automation-poc

Sample repo to demonstrate a Hello World-style Microsoft Fabric deployment layout and the GitHub automation that can validate it.

## Repository layout

```text
fabric/
  HelloWorld.Notebook/
    .platform
    notebook-content.py
.github/workflows/
  validate-fabric-layout.yml
```

- `fabric/HelloWorld.Notebook` is a minimal Fabric notebook item that can be used as the first asset in a Fabric workspace connected to this repository.
- `.github/workflows/validate-fabric-layout.yml` checks that Fabric item folders include required metadata and that the Hello World notebook source is present.

The `logicalId` in `fabric/HelloWorld.Notebook/.platform` is a placeholder for this sample. Fabric Git integration may regenerate or remap item identifiers when the workspace is first synchronized.

## Getting started

1. Create or choose a Microsoft Fabric workspace.
2. Connect the workspace to this repository using Fabric Git integration.
3. Sync the `fabric/` folder into the workspace.
4. Open the `HelloWorld` notebook and run it to print a sample message.

Future automation can build on the validation workflow by adding authenticated deployment steps once the target workspace and credentials are available.
