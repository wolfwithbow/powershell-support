﻿<#
DONE-List of installed company applications, including versions and build number
DONE-System information, including OS version, machine build
DONE-Current connected devices, including model and make

DONE-Latest windows updates and date installed

Power management settings for windows
USB root hub power settings for USB power devices


Confirm if the application is authenticated via single sign-on
FQDN of the host server the application it should be currently connecting to
Confirm if the machine can ping the application server
Test the machine's connection to the database server

Whilst I was re-writing this list a few more came up (oops) [10/03/2018]
Confirm that the time on the machine is correct
Confirm the application user cache setting
Check if the required ports on firewall have been enabled


#Out-File -filepath C:\Powershell\test.txt
#>

Write-Host "# --------------------------------------"
Write-Host "# Return list of installed company applications, including versions and build number"
Write-Host "# --------------------------------------"
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


Write-Host "# --------------------------------------"
Write-Host "# Local IP address information"
Write-Host "# System information, including OS version, machine build"
Write-Host "# --------------------------------------"
$colItems = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" |
 where{$_.IPEnabled -eq "True"}

foreach($objItem in $colItems) { 
 Write-Host "Adapter:" $objItem.Description 
 Write-Host " DNS Domain:" $objItem.DNSDomain
 Write-Host " IPv4 Address:" $objItem.IPAddress[0]
 Write-Host " IPv6 Address:" $objItem.IPAddress[1]
 Write-Host " " 
}


Write-Host "# --------------------------------------"
Write-Host "# Retrieve current device information"
Write-Host "# Local IP address information"
Write-Host "# --------------------------------------"
$DeviceInfo = Get-ItemProperty -path HKCU:\SOFTWARE\BigHand\BHRecorder
$IPInfo = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" |
 where{$_.IPEnabled -eq "True"}
$SystemInfo = Get-WmiObject -Class Win32_ComputerSystem

foreach($objItem in $DeviceInfo) { 
 Write-Host " Recording Device is currently set to:      :" $objItem.RecordingDeviceName
 Write-Host " Playback Device is currently set to:       :" $objItem.PlaybackDeviceName
 Write-Host " Device is installed here:                  :" $objItem.PSPath
 Write-Host " Device Driver ID:                          :" $objItem.DeviceDriver
 Write-Host " Recording Volume level:                    :" $objItem.RecordingVolume
 Write-Host " Playback Volume level:                     :" $objItem.PlaybackVolume
 Write-Host " Current Codec Setting:                     :" $objItem.DefaultLocalCodec
 Write-Host " " 
}
foreach($objItem in $IPInfo) { 
 Write-Host "Adapter:" $objItem.Description 
 Write-Host " DNS Domain:" $objItem.DNSDomain
 Write-Host " IPv4 Address:" $objItem.IPAddress[0]
 Write-Host " IPv6 Address:" $objItem.IPAddress[1]
 Write-Host " " 
}
foreach($objItem in $SystemInfo) { 
 Write-Host "Domain    :" $objItem.Domain
 Write-Host "PC        :" $objItem.Manufacturer
 Write-Host "Model     :" $objItem.Model
 Write-Host " " 
}
foreach($objItem in $SystemInfo) { 
 Write-Host "Domain    :" $objItem.Domain
 Write-Host "PC        :" $objItem.Manufacturer
 Write-Host "Model     :" $objItem.Model
 Write-Host " " 
}


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


# -------------------------------------- 
# Check SQL Browser Service Connection 
# -------------------------------------- 
Browser service listening on LOND691.TEST

Loop through the response string ... 
ForEach ($ds in $DataSourceList) {
 
 $result = Invoke-SQL $ds "master" "select @@BIGHAND2K8"
 
 if ($result) { 
   Write-Host "Successful SQL connection to $ds" 
  } else { 
   Write-Host "Failed to connect to $ds" 
  } 
} 