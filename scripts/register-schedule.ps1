# Registers two daily tasks for the current user: 08:55 morning goals, 17:00 evening results.
# Remove with: Unregister-ScheduledTask -TaskName work-reporter-morning, work-reporter-evening -Confirm:$false
$run = Join-Path $PSScriptRoot 'run.ps1'
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable

foreach ($t in @(
        @{ Name = 'work-reporter-morning'; At = '08:55'; Mode = 'morning' },
        @{ Name = 'work-reporter-evening'; At = '17:00'; Mode = 'evening' })) {
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$run`" -Mode $($t.Mode)"
    $trigger = New-ScheduledTaskTrigger -Daily -At $t.At
    Register-ScheduledTask -TaskName $t.Name -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
    Write-Output "registered $($t.Name) at $($t.At)"
}
