################################################################################
##  File: Install-Git.ps1
##  Desc: Install Git via Chocolatey
################################################################################

Write-Host "Installing Git..."

choco install git -y --no-progress

# Refresh PATH so git is available immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Verify installation
git --version
Write-Host "Git installed successfully"
