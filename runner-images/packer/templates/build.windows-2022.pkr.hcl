build {
  sources = ["source.azure-arm.windows"]

  provisioner "powershell" {
    inline = [
      "New-Item -Path 'C:\\image' -ItemType Directory -Force",
      "New-Item -Path 'C:\\image\\scripts' -ItemType Directory -Force",
    ]
  }

  provisioner "file" {
    source      = "${path.root}/../scripts/build/"
    destination = "C:\\image\\scripts\\build\\"
  }

  provisioner "powershell" {
    script = "${path.root}/../scripts/build/Install-Chocolatey.ps1"
  }

  provisioner "powershell" {
    script = "${path.root}/../scripts/build/Install-Git.ps1"
  }

  provisioner "powershell" {
    inline = [
      "git --version",
      "Write-Host 'Git verification succeeded'",
    ]
  }

  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while ($true) {",
      "  $imageState = (Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State).ImageState",
      "  Write-Output $imageState",
      "  if ($imageState -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { break }",
      "  Start-Sleep -Seconds 10",
      "}",
      "Write-Output 'Sysprep complete'",
    ]
  }
}
