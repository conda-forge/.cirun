# cirun.io config

This repository contains configuration details for the cirun.io service.

## Available resources

In order to request access, please refer to `conda-forge/admin-requests`.

<!--
  Please make sure to document all available resources by mentioning them
  in the relevant provider section (or create one if necessary), along
  with the necessary details and references.
-->

### OpenStack instance

Provides long-running CPU and GPU jobs for native `linux-64`.

Provided by Quansight's [`open-gpu-server`](https://github.com/Quansight/open-gpu-server).
Check their README for the technical specs of each flavor.

| `name`                        | OpenStack flavor |
| ----------------------------- | ---------------- |
| `cirun-openstack-gpu-large`   | `gpu_large`      |
| `cirun-openstack-gpu-xlarge`  | `gpu_xlarge`     |
| `cirun-openstack-gpu-2xlarge` | `gpu_2xlarge`    |
| `cirun-openstack-gpu-4xlarge` | `gpu_4xlarge`    |
| `cirun-openstack-cpu-medium`  | `ci_medium`      |
| `cirun-openstack-cpu-large`   | `ci_large`       |
| `cirun-openstack-cpu-xlarge`  | `ci_xlarge`      |
| `cirun-openstack-cpu-2xlarge` | `ci_2xlarge`     |
| `cirun-openstack-cpu-4xlarge` | `ci_4xlarge`     |

### Windows runners

Long-running CPU jobs for native `win-64`.

Provided by Prefix.dev-sponsored Azure instances. Images are built with Packer — see [`runner-images/`](runner-images/) for details.

| `name`                          | Azure instance        |
| ------------------------------- | --------------------- |
| `cirun-azure-windows-2xlarge`   | `Standard_D8ads_v5`   |
| `cirun-azure-windows-4xlarge`   | `Standard_D16ads_v5`  |

### macOS runners

Long-running CPU jobs for native `osx-arm64`.

Provided by Prefix.dev-sponsored Scaleway instances.

| `name`                 | Scaleway instance |
| ---------------------- | ----------------- |
| `cirun-macos-m4-large` | `8vcpu-8gb-75gb`  |
