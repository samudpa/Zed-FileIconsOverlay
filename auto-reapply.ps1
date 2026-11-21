$stale = Get-ChildItem 'HKCU:\Software\Classes' |
  Where-Object { $_.PSChildName -like 'Zed.*' } |
  Where-Object {
    $k = Get-Item "$($_.PSPath)\DefaultIcon" -ErrorAction SilentlyContinue
    -not $k -or $k.GetValue('') -notlike '*ZedFileIcons*'
  }
if ($stale) { & "$PSScriptRoot\install.ps1" }