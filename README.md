# kiro-open

A tiny, near-zero-resource Windows helper that **stops your laptop from going to sleep while Kiro Crew is open** — and gets out of the way the moment Kiro Crew closes.

## What it does

- While any `KiroCrew` process is running, it holds the Windows "stay awake" flag
  (via `SetThreadExecutionState`, the same API media players use).
- It re-checks every 15 seconds — effectively **0% CPU**, no admin rights needed.
- When Kiro Crew closes, it clears the flag and exits on its own, so **normal
  sleep behaviour returns automatically**.
- By default it also keeps the **screen** on (set `$KeepDisplayOn = $false` in
  `keep-awake.ps1` for system-only).

## Files

| File | Purpose |
|------|---------|
| `keep-awake.ps1`      | The watcher script. |
| `run.bat`             | Double-click launcher — starts the watcher hidden in the background. |
| `install-startup.ps1` | Adds a Startup-folder shortcut so it auto-runs at every login. |

## Use it

**Run once, now:** double-click `run.bat`.

**Auto-start at login:** run
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install-startup.ps1
```

**Stop it:** close Kiro Crew (it exits itself), or end the hidden `powershell.exe`
running `keep-awake.ps1` from Task Manager.

## Settings (top of `keep-awake.ps1`)

| Setting | Default | Meaning |
|---------|---------|---------|
| `$ProcessName`   | `KiroCrew` | Process to watch for. |
| `$CheckSeconds`  | `15` | Seconds between checks (higher = even less work). |
| `$KeepDisplayOn` | `$true` | Keep the screen on too, not just the system. |
| `$WaitForStart`  | `$true` | If Kiro Crew isn't open yet, wait for it instead of exiting. |
