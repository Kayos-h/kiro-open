# ============================================================
#  kiro-open : keep laptop awake while Kiro Crew is open
# ------------------------------------------------------------
#  - Uses the Windows power API (SetThreadExecutionState), the
#    same mechanism media players use. Near-zero CPU: it just
#    sets a "stay awake" flag and sleeps between checks.
#  - While a process named "KiroCrew" is running, the system
#    (and optionally the display) will not go to sleep.
#  - When Kiro Crew closes, the flag is cleared and this exits,
#    so normal sleep behaviour returns automatically.
# ============================================================

# --- settings ----------------------------------------------
$ProcessName   = 'KiroCrew'   # process to watch for
$CheckSeconds  = 15           # how often to re-check (higher = even less work)
$KeepDisplayOn = $true        # $true = also keep the SCREEN on, not just the system
$WaitForStart  = $true        # if Kiro Crew isn't open yet, wait for it instead of exiting
# -----------------------------------------------------------

Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class Awake {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
'@

$ES_CONTINUOUS       = [uint32]0x80000000
$ES_SYSTEM_REQUIRED  = [uint32]0x00000001
$ES_DISPLAY_REQUIRED = [uint32]0x00000002

function Set-StayAwake {
    $flags = $ES_CONTINUOUS -bor $ES_SYSTEM_REQUIRED
    if ($KeepDisplayOn) { $flags = $flags -bor $ES_DISPLAY_REQUIRED }
    [Awake]::SetThreadExecutionState($flags) | Out-Null
}
function Clear-StayAwake {
    [Awake]::SetThreadExecutionState($ES_CONTINUOUS) | Out-Null
}

function Test-KiroRunning {
    return [bool](Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
}

# If Kiro Crew isn't open yet, optionally wait for it to appear.
if (-not (Test-KiroRunning)) {
    if ($WaitForStart) {
        while (-not (Test-KiroRunning)) { Start-Sleep -Seconds $CheckSeconds }
    } else {
        Clear-StayAwake
        return
    }
}

# Main loop: hold the flag while Kiro Crew is open.
try {
    while (Test-KiroRunning) {
        Set-StayAwake
        Start-Sleep -Seconds $CheckSeconds
    }
}
finally {
    # Kiro Crew closed (or script stopped) -> let the laptop sleep normally again.
    Clear-StayAwake
}
