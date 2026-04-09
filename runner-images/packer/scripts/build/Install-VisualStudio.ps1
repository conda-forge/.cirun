################################################################################
##  File:  Install-VisualStudio.ps1
##  Desc:  Install Visual Studio
################################################################################
$vsToolset = (Get-ToolsetContent).visualStudio

# Install Visual Studio for Windows 22 and 25 with InstallChannel
Install-VisualStudio `
    -Version $vsToolset.subversion `
    -Edition $vsToolset.edition `
    -Channel $vsToolset.channel `
    -InstallChannelUri $vsToolset.installChannelUri `
    -RequiredComponents $vsToolset.workloads `
    -ExtraArgs "--allWorkloads --includeRecommended --remove Component.CPython3.x64"

# Find the version of VS installed for this instance
# Only supports a single instance
$vsProgramData = Get-Item -Path "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances"
$instanceFolders = Get-ChildItem -Path $vsProgramData.FullName

if ($instanceFolders -is [array]) {
    throw "More than one instance installed"
}

if (Test-IsWin22) {
    # Install Windows 10 SDK version 10.0.17763
    Install-Binary -Type EXE `
    -Url 'https://go.microsoft.com/fwlink/p/?LinkID=2033908' `
    -InstallArgs @("/q", "/norestart", "/ceip off", "/features OptionId.UWPManaged OptionId.UWPCPP OptionId.UWPLocalized OptionId.DesktopCPPx86 OptionId.DesktopCPPx64 OptionId.DesktopCPParm64") `
    -ExpectedSubject $(Get-MicrosoftPublisher)
}

# Install Windows 11 SDK version 10.0.26100
Install-Binary -Type EXE `
    -Url 'https://go.microsoft.com/fwlink/?linkid=2349110' `
    -InstallArgs @("/q", "/norestart", "/ceip off", "/features OptionId.UWPManaged OptionId.UWPCPP OptionId.UWPLocalized OptionId.DesktopCPPx86 OptionId.DesktopCPPx64 OptionId.DesktopCPParm64") `
    -ExpectedSubject $(Get-MicrosoftPublisher)

# Enable Windows Desktop Debuggers (cdb.exe) on Windows Server 2025
if (Test-IsWin25) {
    $installerEntry = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
        | Where-Object { $_.DisplayName -match "Windows Software Development Kit" } `
        | Sort-Object DisplayVersion -Descending | Select-Object -First 1

    if ($installerEntry -and $installerEntry.BundleCachePath) {
        Install-Binary -Type EXE `
            -LocalPath $installerEntry.BundleCachePath `
            -InstallArgs @("/features", "OptionId.WindowsDesktopDebuggers", "/q", "/norestart") `
            -ExpectedSubject $(Get-MicrosoftPublisher)
    }
}
