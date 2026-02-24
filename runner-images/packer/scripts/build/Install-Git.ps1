################################################################################
##  File: Install-Git.ps1
##  Desc: Install Git via Chocolatey
################################################################################

Write-Host "Installing Git..."

# for installation options see https://community.chocolatey.org/packages/git, resp.
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/git.install/ARGUMENTS.md
choco install git -y --no-progress --params "'/GitAndUnixToolsOnPath'"

# Refresh PATH so git is available immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Verify installation
git --version
bash --version
Write-Host "Git installed successfully"
