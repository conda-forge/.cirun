# cirun.io config

This repository contains configuration details for the cirun.io service.

## Available resources

In order to request access, please refer to `conda-forge/admin-requests`.

<!--
  Please make sure to document all available resources by mentioning them
  in the relevant provider section (or create one if necessary), along
  with the necessary details and references.
-->

### Windows runners

Long-running CPU jobs for native `win-64`.

Provided by Prefix.dev-sponsored Azure instances. Images are built with Packer — see [`runner-images/`](runner-images/) for details.

| `name`                          | Azure instance        |
| ------------------------------- | --------------------- |
| `cirun-azure-windows-2xlarge`   | `Standard_D8ads_v5`   |
| `cirun-azure-windows-4xlarge`   | `Standard_D16ads_v5`  |
| `cirun-azure-windows-2xlarge-ng`| DO NOT USE |
| `cirun-azure-windows-4xlarge-ng`| DO NOT USE |

### macOS runners

Long-running CPU jobs for native `osx-arm64`.

Provided by Prefix.dev-sponsored Scaleway instances.

| `name`                 | Scaleway instance |
| ---------------------- | ----------------- |
| `cirun-macos-m4-large` | `8vcpu-8gb-75gb`  |
