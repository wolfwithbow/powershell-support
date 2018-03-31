<#
    Resource: http://tommymaynard.com/write-functions-not-scripts-part-iv-2018/
#>

#Hardcoded
$array = '.NET*','Terminal*', 'bighand*','dragon*'

Write-Host "# --------------------------------------"
Write-Host "# Return list of installed company applications, including versions and build number"
Write-Host "# --------------------------------------"
function Get-Programs {
    param ($param)
    Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
    where {$_.DisplayName -like $param}
}
foreach ($item in $array){
    Get-Programs -param $item | SELECT DisplayName, Comments | 
    Format-Table –AutoSize
}

Write-Host "# --------------------------------------"
Write-Host "# Retrieve current device information"
Write-Host "# Local IP address information"
Write-Host "# --------------------------------------"
    $DeviceInfo = Get-ItemProperty -path HKCU:\SOFTWARE\BigHand\BHRecorder
    $IPInfo = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" |
        where{$_.IPEnabled -eq "True"}
    $PCInfo = Get-WmiObject -Class Win32_ComputerSystem
    $SystemInfo = Get-WmiObject -Class Win32_OperatingSystem

foreach($objItem in $DeviceInfo) { 
    Write-Host " Recording Device is currently set to       :" $objItem.RecordingDeviceName
    Write-Host " Playback Device is currently set to        :" $objItem.PlaybackDeviceName
    Write-Host " Device is installed here                   :" $objItem.PSPath
    Write-Host " Device Driver ID                           :" $objItem.DeviceDriver
    Write-Host " Recording Volume level                     :" $objItem.RecordingVolume
    Write-Host " Playback Volume level                      :" $objItem.PlaybackVolume
    Write-Host " Current Codec Setting                      :" $objItem.DefaultLocalCodec
    Write-Host " " 
}
foreach($objItem in $IPInfo) { 
    Write-Host "Adapter                                     :" $objItem.Description 
    Write-Host " DNS Domain                                 :" $objItem.DNSDomain
    Write-Host " IPv4 Address                               :" $objItem.IPAddress[0]
    Write-Host " IPv6 Address                               :" $objItem.IPAddress[1]
    Write-Host " " 
}
foreach($objItem in $SystemInfo) { 
    Write-Host "Machine Model                               :" $objItem.Model
    Write-Host " " 
}
foreach($objItem in $PCInfo) { 
    Write-Host "PC is Registered to Domain                  :" $objItem.Domain
    Write-Host "PC from                                     :" $objItem.Manufacturer
    Write-Host " " 
}
foreach($objItem in $SystemInfo) { 
    Write-Host "Machine Operating System         :" $objItem.Caption
    Write-Host "OSArchitecture                   :" $objItem.OSArchitecture
    #Get-ProductInfo
        if ($Error.Count -gt 0) { 
            Write-Host "An error occured while trying to determine ProductType" 
        } 
        else { 
            switch ($SystemInfo.ProductType)  
            {  
                1 {"Environment:         This is a Local Workstation"}  
                2 {"Environment:         This is a Domain Controller"}  
                3 {"Environment:         This is a Server"}  
                default {"This is a not a known Product Type"} 
            }
         }
    Write-Host "Was Last Rebooted                :" $objItem.LastBootUpTime
    Write-Host "Current date/time on machine     :" $objItem.LocalDateTime
    Write-Host " " 
}

function GetUpdateInfo {
    Get-WmiObject -Class Win32_QuickFixEngineering
}
GetUpdateInfo | FT –AutoSize





Get-ChildItem -Path HKCU:\Software -Recurse | Where-Object -FilterScript {($_.SubKeyName -le 1) -and ($_.ValueCount -eq 4) } | Out-File -filepath C:\Powershell\test.txt





gwmi Win32_SystemDriver -List | select name,@{n="version";e={(gi $_.pathname).VersionInfo.FileVersion}}

Get-Device -ControlOptions DIGCF_ALLCLASSES | Sort-Object -Property Name | Where-Object -Property IsPresent -eq $false | ft Name, DriverVersion, DriverProvider, IsPresent, HasProblem -AutoSize


##https://foxdeploy.com/2015/07/31/using-powershell-to-find-drivers-for-device-manager/
###https://deploymentresearch.com/Research/Post/306/Back-to-basics-Finding-Lenovo-drivers-and-certify-hardware-control-freak-style
Get-WmiObject Win32_PNPEntity | Where-Object{$_.PNPDeviceID -ne 0} | FT –AutoSize | Out-file C:\Powershell\output.txt

Select Name, DeviceID


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




$colFiles = Get-ChildItem C:\Windows -include *.dll -recurse

foreach ($objFile in $colFiles)
    {
        $i++
        $intSize = $intSize + $objFile.Length
        Write-Progress -activity "Adding File Sizes" -status "Percent added: " -PercentComplete (($i / $colFiles.length)  * 100)

    }

$intSize = "{0:N0}" -f $intSize

Write-Host "Total size of .DLL files: $intSize bytes."





$Events = Get-Eventlog -LogName system -Newest 1000
PS C:\> $Events | Group-Object -Property source -noelement | Sort-Object -Property count -Descending


Write-Host "# --------------------------------------"
Write-Host "# Retrieve last 100 Application Events"
Write-Host "# --------------------------------------"
PowerShell -Command "Get-EventLog -LogName Application"
$bighandevents = get-eventlog -logname Application -newest 10  | Format-Table -Wrap -AutoSize

Write-Host "# --------------------------------------"
Write-Host "# Retrieve last 100 BigHand Events"
Write-Host "# --------------------------------------"
PowerShell -Command "Get-EventLog -LogName BigHand"
$bighandevents = get-eventlog -logname BigHand -newest 100  | Format-Table -Wrap -AutoSize

Write-Host "# --------------------------------------"
Write-Host "# Retrieve last 100 Security Events"
Write-Host "# --------------------------------------"
PowerShell -Command "Get-EventLog -LogName Security"
$bighandevents = get-eventlog -logname Security -newest 100  | Format-Table -Wrap -AutoSize



$events | select-string -pattern 'Bighand'


$bighandevents | -inputobject {$_.Source} -pattern "BigHand"


#$events | select-string -inputobject {$_} | Sort-Object LastWriteTime -Descending




#
$Events = Get-Eventlog -LogName BigHand -Newest 1000
$Events | Group-Object -Property source -noelement | Sort-Object -Property count -Descending

#Get all events in an event log that have include a specific word in the message value
Get-EventLog -LogName "Bighand" -Message "*Creating**"

#Display the property values of an event in a list
$A = Get-EventLog -Log System -Newest 1
$A | Format-List -Property *


#Get all errors in an event log that occurred during a specific time frame
$May31 = Get-Date 10/01/2018
$July1 = Get-Date 20/03/2018
Get-EventLog -Log "Bighand" -EntryType Error -After $May31 -before $July1 | Format-Table -Wrap -AutoSize |  out-file C:\Powershell\event.txt


