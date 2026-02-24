build {
  # "arm" has nothing to do with the processor architecture here, but stands for Azure Resource Manager;
  # we cannot rename it, because the upstream resource definition we're using is named like that, see
  # https://developer.hashicorp.com/packer/integrations/hashicorp/azure/latest/components/builder/arm#basic-example
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
    script = "${path.root}/../scripts/build/Install-BasePackages.ps1"
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
