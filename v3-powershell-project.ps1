<#
DONE-System information, including OS version, machine build
DONE-Latest windows updates and date installed
DONE-Current connected devices, including model and make

Power management settings for windows
USB root hub power settings for USB power devices

DONE-List of installed company applications, including versions and build number
Confirm if the application is authenticated via single sign-on
FQDN of the host server the application it should be currently connecting to
Confirm if the machine can ping the application server
Test the machine's connection to the database server

Whilst I was re-writing this list a few more came up (oops) [10/03/2018]
Confirm that the time on the machine is correct
Confirm the application user cache setting
Check if the required ports on firewall have been enabled
#>

#####Return Installed Programs
function GetPrograms {

    param ($param)
    Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
    where {$_.DisplayName -like $param}

}

$array = '.NET*','Terminal*', 'bighand*','dragon*'

foreach ($item in $array){

    GetPrograms -param $item | SELECT DisplayName, Comments |
    Format-Table –AutoSize

}


#####Retrieve current device information
function GetCurrentDevice {
    
    Get-ItemProperty 'HKCU:\SOFTWARE\BigHand\BHRecorder\' | SELECT RecordingDeviceName, PlaybackDeviceName, PSPath, DeviceDriver, RecordingVolume, PlaybackVolume, DefaultLocalCodec

}

GetCurrentDevice -list


#####System Info and Windows Updates
#Considerations
#searchable by required info
#add - memory info
function GetSystemInfo {
    Get-WmiObject -Class Win32_ComputerSystem
}

GetSystemInfo Format-Table –AutoSize


function GetUpdateInfo {
    Get-WmiObject -Class Win32_QuickFixEngineering
}

GetUpdateInfo Format-Table –AutoSize


#####Device Manager and Power Management Settings


Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, CSName | FL


Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion

Get-ChildItem -Path HKCU:\Software -Recurse | Where-Object -FilterScript {($_.SubKeyName -le 1) -and ($_.ValueCount -eq 4) }




gwmi Win32_SystemDriver -List | select name,@{n="version";e={(gi $_.pathname).VersionInfo.FileVersion}}

Get-Device -ControlOptions DIGCF_ALLCLASSES | Sort-Object -Property Name | Where-Object -Property IsPresent -eq $false | ft Name, DriverVersion, DriverProvider, IsPresent, HasProblem -AutoSize


##https://foxdeploy.com/2015/07/31/using-powershell-to-find-drivers-for-device-manager/
###https://deploymentresearch.com/Research/Post/306/Back-to-basics-Finding-Lenovo-drivers-and-certify-hardware-control-freak-style
Get-WmiObject Win32_PNPEntity | Where-Object{$_.PNPDeviceID -ne 0} | Select Name, DeviceID