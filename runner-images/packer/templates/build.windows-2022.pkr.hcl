build {
  # "arm" has nothing to do with the processor architecture here, but stands for Azure Resource Manager;
  # we cannot rename it, because the upstream resource definition we're using is named like that, see
  # https://developer.hashicorp.com/packer/integrations/hashicorp/azure/latest/components/builder/arm#basic-example
  sources = ["source.azure-arm.windows"]

  provisioner "file" {
    destination = "${var.image_folder}\\"
    sources     = [
      "${path.root}/../scripts",
      "${path.root}/../toolsets"
     ]
   }

  provisioner "powershell" {
    inline = [
      # expected to exist by conda-build
      "New-Item -Path 'C:\\bld' -ItemType Directory -Force",
      # support infrastructure from https://github.com/actions/runner-images
      "Move-Item '${var.image_folder}\\scripts\\helpers' '${var.helper_script_folder}\\ImageHelpers'",
      "New-Item -Type Directory -Path '${var.helper_script_folder}\\TestsHelpers\\'",
      "Move-Item '${var.image_folder}\\scripts\\tests\\Helpers.psm1' '${var.helper_script_folder}\\TestsHelpers\\TestsHelpers.psm1'",
    ]
  }

  provisioner "powershell" {
    script = "${path.root}/../scripts/build/Install-Chocolatey.ps1"
  }

  provisioner "powershell" {
    script = "${path.root}/../scripts/build/Install-BasePackages.ps1"
  }

  # enable long paths on windows
  provisioner "powershell" {
    inline = [
      "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem' -Name 'LongPathsEnabled' -Value 1"
    ]
  }
  # needs restart to take effect
  provisioner "windows-restart" {}

  provisioner "powershell" {
    inline = [
      "git config --system core.longpaths true",
      "Write-Host 'Git setup succeeded'",
    ]
  }

  provisioner "powershell" {
    elevated_password = "${var.install_password}"
    elevated_user     = "${var.install_user}"
    environment_vars  = ["IMAGE_FOLDER=${var.image_folder}", "TEMP_DIR=${var.temp_dir}"]
    scripts           = [
      "${path.root}/../scripts/build/Install-VisualStudio.ps1",
    ]
    valid_exit_codes  = [0, 3010]
  }

  provisioner "windows-restart" {
    check_registry  = true
    restart_timeout = "10m"
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
