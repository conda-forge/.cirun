# Runner Images

Packer templates for building CI runner images on Azure, using the Azure account sponsored by [prefix.dev](https://prefix.dev) (tenant: `1663b411-...`, subscription: `df033e15-...`).

## Windows Server 2022

Builds a Windows Server 2022 image with:
- Chocolatey
- Git
- bash
- pwsh
- 7z
- MSVC

## CI Workflow

The `build-image.yml` workflow validates Packer templates on PRs and builds images on push to `main` or manual dispatch.

### GitHub Secrets

| Secret | Description |
|---|---|
| `WINDOWS_CI_AZURE_CLIENT_ID` | App registration client ID (used for OIDC login) |
| `WINDOWS_CI_AZURE_TENANT_ID` | Azure AD tenant ID |
| `WINDOWS_CI_AZURE_SUBSCRIPTION_ID` | Azure subscription ID |

No client secrets are needed — the workflow authenticates via OIDC federated credentials. These values are not sensitive (they are just identifiers, not credentials), but are stored as secrets for convenience.

### Azure OIDC Setup

Run the setup script to create the app registration, service principal, role assignment, and federated credential:

```bash
./runner-images/setup-azure-oidc.sh <GITHUB_ORG/REPO>
# Example:
./runner-images/setup-azure-oidc.sh conda-forge/.cirun
```

The GitHub repo argument is required because the OIDC federated credential is scoped to a specific repository — only GitHub Actions workflows running from that repo are allowed to authenticate as the Azure app.

The script prints the GitHub secrets to set. Then add them:

```bash
gh secret set WINDOWS_CI_AZURE_CLIENT_ID --body "<value>"
gh secret set WINDOWS_CI_AZURE_TENANT_ID --body "<value>"
gh secret set WINDOWS_CI_AZURE_SUBSCRIPTION_ID --body "<value>"
```

Prerequisites: `az` (Azure CLI, logged in to the prefix.dev-sponsored Azure account with the correct subscription selected) and `jq`. The script is idempotent and safe to re-run.

## Updating the Runner Image

After a new image is built, copy the **Image ID** from the build summary and update the `machine_image` field for the Windows runners in `.cirun.global.yml`.

## Build Locally

Requires Azure CLI login (`az login`):

```bash
packer init runner-images/packer/templates/
packer build \
  -var "use_azure_cli_auth=true" \
  -var "managed_image_resource_group_name=<resource-group>" \
  -var "managed_image_name=cirun-win22-$(date +%Y%m%d)" \
  -var "location=UK South" \
  runner-images/packer/templates/
```
