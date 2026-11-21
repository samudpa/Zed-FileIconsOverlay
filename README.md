```powershell
$a  = New-ScheduledTaskAction -Execute conhost.exe -Argument '--headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\auto-reapply.ps1"'
$t1 = New-ScheduledTaskTrigger -AtLogOn
$t2 = New-ScheduledTaskTrigger -Daily -At HH:mm
Register-ScheduledTask -TaskName ZedIconsReapply -Action $a -Trigger $t1,$t2 -Force `
  -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)
```