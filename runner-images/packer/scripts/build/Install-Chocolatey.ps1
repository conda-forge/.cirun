################################################################################
##  File: Install-Chocolatey.ps1
##  Desc: Install Chocolatey package manager
################################################################################

Write-Host "Installing Chocolatey..."

# Set TLS 1.2 as the default for web requests
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Enable global confirmation so choco install doesn't prompt
choco feature enable -n allowGlobalConfirmation

Write-Host "Chocolatey installed successfully"
choco --version
