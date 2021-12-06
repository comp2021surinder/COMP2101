function networkInfo {
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled |
format-table @{n="Description" ; width = 15 ; e={$_.description}},
@{n="Index" ; width = 15 ; e={$_.index}},
@{n="IPAddress" ; width = 25 ; e={$_.ipaddress}},
@{n="IPSubnet" ; width = 20 ; e={$_.ipsubnet}},
@{n="DNSDomain" ; width = 20 ; e={$_.DNSDomain}},
@{n="DNSServer" ; width = 20 ; e={$_.DNSServerSearchOrder}}
}

function HardwareInformation {
Write-Output "======= HARDWARE DESCRIPTION ======="
Get-WmiObject win32_computersystem | Format-List Domain, Name, Manufacturer, Model, TotalPhysicalMemory
}

function OSInformation {
Write-Output "======= OS DESCRIPTION ======="
Get-WmiObject win32_operatingsystem | Format-List Name, Version
}

function CPUInformation {
Write-Output "========== PROCESSOR INFORMATION =========="
Get-WmiObject win32_processor | Select-Object Name, NumberOfCores, CurrentClockSpeed, MaxClockSpeed,
@{n="L1CacheSize";e={switch($_.L1CacheSize){$Null{$myvar="No information found."; $myvar}};if($Null -ne $_.L1CacheSize){$_.L1CacheSize}}},
@{n="L2CacheSize";e={switch($_.L2CacheSize){$Null{$myvar="No information found."; $myvar}};if($Null -ne $_.L2CacheSize){$_.L2CacheSize}}},
@{n="L3CacheSize";e={switch($_.L3CacheSize){$Null{$myvar="No information found."; $myvar}};if($Null -ne $_.L3CacheSize){$_.L3CacheSize}}}
}

function RAMInformation {
Write-Output "========== RAM INFORMATION =========="
$totalRamCapacity = 0
Get-WmiObject win32_physicalmemory |
ForEach-Object {
$currentRam = $_ ;
New-Object -TypeName psObject -Property @{
Manufacturer = $currentRam.Manufacturer
Description  = $currentRam.Description
"Size(GB)"   = $currentRam.Capacity / 1gb
Bank         = $currentRam.banklabel
Slot         = $currentRam.devicelocator
}
$totalRamCapacity += $currentRam.Capacity
} |
Format-Table Manufacturer, Description, "Size(GB)", Bank, Slot -AutoSize
Write-Output "Total RAM Capacity = $($totalRamCapacity/1gb) GB"
}


function DiskDriveInformation {
Write-Output "========== DISK DRIVE INFORMATION =========="
$allDiskDrives = Get-CIMInstance CIM_diskdrive | Where-Object DeviceID -ne $null
foreach ($currentDisk in $allDiskDrives) {
$allPartitions = $currentDisk | get-cimassociatedinstance -resultclassname CIM_diskpartition
foreach ($currentPartition in $allPartitions) {
$allLogicalDisks = $currentPartition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
foreach ($currentLogicalDisk in $allLogicalDisks) {
new-object -typename psobject -property @{
Model          = $currentDisk.Model
Manufacturer   = $currentDisk.Manufacturer
Location       = $currentPartition.deviceid
Drive          = $currentLogicalDisk.deviceid
"Size(GB)"     = [string]($currentLogicalDisk.size / 1gb -as [int]) + 'GB'
FreeSpace      = [string]($currentLogicalDisk.FreeSpace / 1gb -as [int]) + 'GB'
"FreeSpace(%)" = ([string]((($currentLogicalDisk.FreeSpace / $currentLogicalDisk.Size) * 100) -as [int]) + '%')
} | Format-Table -AutoSize
} 
}
}   
}

function NetworkInformation {
Write-Output "======= NETWORK INFORMATION ======="
Get-WmiObject Win32_NetworkAdapterconfiguration |
where {$_.ipenabled -eq "True" } | Format-Table Description, Index, IPAddress, IPSubnet,
@{n="DNSHostName";e={switch($_.DNSDomain){$Null{$myvar="No information found here."; $myvar}};if($Null -ne $_.DNSDomain){$_.DNSDomain}}},
@{n="DNSServerOrder";e={switch($_.DNSServersearchorder){$Null{$myvar="No information found here."; $myvar}};if($Null -ne $_.DNSServersearchorder){$_.DNSServersearchorder}}}
}

function GraphicsInformation {
Write-Output "========== GRAPHICS INFORMATION =========="
$controllerObject = Get-WmiObject win32_videocontroller
$controllerObject = New-Object -TypeName psObject -Property @{
Name             = $controllerObject.Name
Description      = $controllerObject.Description
ScreenResolution = [string]($controllerObject.CurrentHorizontalResolution) + 'px X ' + [string]($controllerObject.CurrentVerticalResolution) + 'px'
} | Format-List Name, Description, ScreenResolution
$controllerObject
}

# Calling Functions 

HardwareInformation
OSInformation
CPUInformation
RAMInformation
DiskDriveInformation
NetworkInformation
GraphicsInformation