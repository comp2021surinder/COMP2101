param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
if ( !($System) -and !($Disks) -and !($Network)) {
    HardwareInformation
    CPUInformation
    OSInformation
    RAMInformation
    GraphicsInformation
    DiskDriveInformation
    NetworkInformation
}
if ($System) {
    HardwareInformation
    CPUInformation
    OSInformation
    RAMInformation
    GraphicsInformation
}
if ($Disks) {
    DiskDriveInformation
}
if ($Network) {
    NetworkInformation
}