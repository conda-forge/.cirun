packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}

source "azure-arm" "windows" {
  use_azure_cli_auth = var.use_azure_cli_auth

  client_id       = var.client_id != "" ? var.client_id : null
  client_secret   = var.client_secret != "" ? var.client_secret : null
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
  tenant_id       = var.tenant_id != "" ? var.tenant_id : null

  oidc_request_url   = var.oidc_request_url != "" ? var.oidc_request_url : null
  oidc_request_token = var.oidc_request_token != "" ? var.oidc_request_token : null

  location = var.location
  vm_size  = var.vm_size

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2022-datacenter-g2"

  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name

  temp_resource_group_name = var.temp_resource_group_name != "" ? var.temp_resource_group_name : null

  os_disk_size_gb = 256

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "15m"
  winrm_username = "packer"
}
