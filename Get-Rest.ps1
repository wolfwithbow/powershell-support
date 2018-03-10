<#
    .Return Installed Programs
            Get-ProgramInformation gets a list of the installed applications related to BigHand
            
    .Return Installed Device Make and Model
            Get-CurrentDevice -list
            
    .Return System Info
            Get-SystemInfo -List
#>

function Get-ProgramInformation {
param ($param)
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
where {$_.DisplayName -like $param}
}
$GetThesePrograms = '.NET*','Terminal*', 'bighand*','dragon*','windows*'

foreach ($item in $GetThesePrograms){
Get-ProgramInformation -param $item | SELECT DisplayName, Comments
}


#Device information
function Get-CurrentDevice {
Get-ItemProperty 'HKCU:\SOFTWARE\BigHand\BHRecorder\' | SELECT RecordingDeviceName, PlaybackDeviceName, PSPath, DeviceDriver, RecordingVolume, PlaybackVolume, DefaultLocalCodec
}


#SystemInfo
function Get-SystemInfo {
Get-WmiObject -Class Win32_ComputerSystem
}

function Get-UpdateInfo {
Get-WmiObject -Class Win32_QuickFixEngineering
}


#PowerManagement - incomplete
Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, CSName | FL
Enable-PnpDevice

Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion

Get-ChildItem -Path HKCU:\Software | Where-Object -FilterScript {($_.SubKeyName -le 1) -and ($_.ValueCount -eq 4) }


##https://foxdeploy.com/2015/07/31/using-powershell-to-find-drivers-for-device-manager/
###https://deploymentresearch.com/Research/Post/306/Back-to-basics-Finding-Lenovo-drivers-and-certify-hardware-control-freak-style
Get-WmiObject Win32_PNPEntity | Where-Object{$_.PNPDeviceID -ne 0} | Select Name, DeviceID