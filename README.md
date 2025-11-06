# cirun.io config

This repository contains configuration details for the cirun.io service.

## Available resources

In order to request access, please refer to `conda-forge/admin-requests`.

<!--
  Please make sure to document all available resources by mentioning them
  in the relevant provider section (or create of if necessary), along
  with the necessary details and references.
-->

### OpenStack instance

Provided by [`open-gpu-server`](https://github.com/Quansight/open-gpu-server).
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
