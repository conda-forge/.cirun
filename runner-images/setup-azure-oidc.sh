#!/usr/bin/env bash
set -euo pipefail

# Setup Azure OIDC for GitHub Actions image builds.
# Usage: ./setup-azure-oidc.sh <GITHUB_ORG/REPO> [LOCATION]
# Example: ./setup-azure-oidc.sh conda-forge/.cirun uksouth

APP_NAME="cirun-conda-forge-windows-image-packer"

check_prerequisites() {
    if ! command -v az &> /dev/null; then
        echo "Error: Azure CLI (az) is not installed."
        echo "Install it from https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi

    if ! az account show &> /dev/null; then
        echo "Error: Not logged in to Azure CLI. Run 'az login' first."
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed."
        echo "Install it from https://jqlang.github.io/jq/download/"
        exit 1
    fi
}

create_app_registration() {
    echo "==> Creating app registration: ${APP_NAME}"
    APP_JSON=$(az ad app create --display-name "${APP_NAME}" --output json)
    APP_ID=$(echo "$APP_JSON" | jq -r '.appId')
    APP_OBJECT_ID=$(echo "$APP_JSON" | jq -r '.id')
    echo "    App ID (client ID): ${APP_ID}"
    echo "    Object ID: ${APP_OBJECT_ID}"
}

create_service_principal() {
    echo "==> Creating service principal"
    az ad sp create --id "${APP_ID}" --output none
}

assign_contributor_role() {
    local subscription_id="$1"
    echo "==> Assigning Contributor role on subscription ${subscription_id}"
    az role assignment create \
        --assignee "${APP_ID}" \
        --role "Contributor" \
        --scope "/subscriptions/${subscription_id}" \
        --output none
}

add_federated_credential() {
    local github_repo="$1"
    echo "==> Adding federated credential for repo:${github_repo}:ref:refs/heads/main"
    az ad app federated-credential create \
        --id "${APP_OBJECT_ID}" \
        --parameters "{
            \"name\": \"github-actions-main\",
            \"issuer\": \"https://token.actions.githubusercontent.com\",
            \"subject\": \"repo:${github_repo}:ref:refs/heads/main\",
            \"audiences\": [\"api://AzureADTokenExchange\"]
        }" --output none
}

main() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <GITHUB_ORG/REPO>"
        echo "Example: $0 conda-forge/.cirun"
        exit 1
    fi

    local github_repo="$1"

    check_prerequisites
    create_app_registration
    create_service_principal

    local subscription_id tenant_id
    subscription_id=$(az account show --query id --output tsv)
    tenant_id=$(az account show --query tenantId --output tsv)

    assign_contributor_role "${subscription_id}"
    add_federated_credential "${github_repo}"

    echo ""
    echo "Done! Set these GitHub secrets on ${github_repo}:"
    echo ""
    echo "  AZURE_CLIENT_ID=${APP_ID}"
    echo "  AZURE_TENANT_ID=${tenant_id}"
    echo "  AZURE_SUBSCRIPTION_ID=${subscription_id}"
}

main "$@"
