# PowerShell command

## Get available drivers

```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName . | Format-Table DeviceId, MediaType, VolumeName, @{n="Size(GB)";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace(GB)";e={[math]::Round($_.FreeSpace/1GB,2)}}
```
