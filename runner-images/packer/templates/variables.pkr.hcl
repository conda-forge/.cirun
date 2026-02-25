variable "client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}
variable "client_secret" {
  type      = string
  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
}
variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}
variable "tenant_id" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
}
variable "location" {
  type    = string
  default = "UK South"
}
variable "managed_image_name" {
  type    = string
  default = "cirun-win22-{{timestamp}}"
}
variable "managed_image_resource_group_name" {
  type = string
}
variable "temp_resource_group_name" {
  type    = string
  default = ""
}
variable "vm_size" {
  type    = string
  default = "Standard_D16ads_v5"
}
variable "image_os" {
  type    = string
  default = "win22"
}
variable "use_azure_cli_auth" {
  type    = bool
  default = false
}
variable "oidc_request_url" {
  type    = string
  default = "${env("ACTIONS_ID_TOKEN_REQUEST_URL")}"
}
variable "oidc_request_token" {
  type    = string
  default = "${env("ACTIONS_ID_TOKEN_REQUEST_TOKEN")}"
}
