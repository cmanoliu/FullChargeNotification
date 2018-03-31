$path = (Resolve-Path .\).Path
$script = "FullChargeNotification.ps1"
$filepath = @"
$($path)\$($script)
"@
$taskname = "FullChargeNotification"
$currentuser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$paramHash = @{
Name = $taskname
FilePath = $filepath
Trigger = (New-Jobtrigger -AtLogOn -User $currentuser -RandomDelay 00:00:30)
ScheduledJobOption = (New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery)
}
$job = Register-ScheduledJob @paramHash

# Making Interactive and disabling "Stop the task if it runs longer than"
$taskPrincipal = New-ScheduledTaskPrincipal -LogonType Interactive -UserId $currentuser
$taskSettings = New-ScheduledTaskSettingsSet –AllowStartIfOnBatteries –DontStopIfGoingOnBatteries -Hidden -ExecutionTimeLimit (New-TimeSpan)  
$task = Set-ScheduledTask -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName $taskname -Principal $taskPrincipal -Settings $taskSettings

# Start immediately
Start-ScheduledTask -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -TaskName $taskname