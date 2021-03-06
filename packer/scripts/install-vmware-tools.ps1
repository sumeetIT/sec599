
Write-Host "Enabling >TLS1.0 for iso download over https..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Downloading vmware tools..."
(New-Object System.Net.WebClient).DownloadFile('https://packages.vmware.com/tools/releases/11.1.5/windows/VMware-tools-windows-11.1.5-16724464.iso', 'C:\Windows\Temp\vmware-tools.iso')


# Extracts two files of 'vmware-tools.zip.tar' of
# previous download: 
#   https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/11.1.0/13668589/packages/com.vmware.fusion.tools.windows.zip.tar
# x com.vmware.fusion.tools.windows.zip
# x descriptor.xml
## cmd /c "tar -xvzf C:\Windows\Temp\vmware-tools.zip.tar -C C:\Windows\Temp\"
# Extract C:\Windows\Temp\com.vmware.fusion.tools.windows.zip
## Expand-Archive C:\Windows\Temp\com.vmware.fusion.tools.windows.zip -DestinationPath C:\Windows\Temp\ -Force

Write-Host "Mountain vmware tools ISO...."
## $mountResult = Mount-DiskImage -ImagePath C:\Windows\Temp\payload\windows.iso -PassThru
$mountResult = Mount-DiskImage -ImagePath C:\Windows\Temp\vmware-tools.iso -PassThru
$driveLetter = ($mountResult | Get-Volume).DriveLetter

Write-Host "Running vmware tools setup/install...."
$vmwareToolsSetupExe = $driveLetter + ':\' + "setup64.exe"
cmd /c "$vmwareToolsSetupExe /s /l C:\\Windows\\Temp\\vmware_tools.log /v`"/qn REBOOT=R`""

Write-Host "Cleaning up vmware tools install...."
## Dismount-DiskImage -ImagePath C:\Windows\Temp\payload\windows.iso
Dismount-DiskImage -ImagePath C:\Windows\Temp\vmware-tools.iso
## Remove-Item  C:\Windows\Temp\vmware-tools.zip.tar
Remove-Item  C:\Windows\Temp\vmware-tools.iso
