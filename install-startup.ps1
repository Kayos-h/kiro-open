# Installs a login-startup shortcut so the watcher runs hidden every time you log in.
$startup  = [Environment]::GetFolderPath('Startup')
$lnkPath  = Join-Path $startup 'kiro-open keep-awake.lnk'
$script   = 'C:\Users\Nitro\Desktop\kiro-open\keep-awake.ps1'

$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($lnkPath)
$sc.TargetPath       = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$sc.Arguments        = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
$sc.WorkingDirectory = 'C:\Users\Nitro\Desktop\kiro-open'
$sc.WindowStyle      = 7   # minimized/hidden
$sc.Description       = 'Keep laptop awake while Kiro Crew is open'
$sc.Save()

if (Test-Path $lnkPath) { Write-Output "INSTALLED: $lnkPath" } else { Write-Output "FAILED to create shortcut" }
