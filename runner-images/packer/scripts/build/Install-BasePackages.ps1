################################################################################
##  File: Install-BasePackages.ps1
##  Desc: Install base packages (git, pwsh, ...) via Chocolatey
################################################################################

Write-Host "Installing Base Packages (git, pwsh, ...)"

# for installation options see https://community.chocolatey.org/packages/git, resp.
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/git.install/ARGUMENTS.md
choco install git -y --no-progress --params "'/GitAndUnixToolsOnPath'"

# necessary to use `shell: pwsh` in GHA
choco install pwsh -y --no-progress

# Refresh PATH so binaries are reachable immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Verify installation
git --version
bash --version
bash -c "pwsh --version"

Write-Host "Base Packages installed successfully"
