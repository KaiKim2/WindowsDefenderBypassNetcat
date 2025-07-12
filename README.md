#Usage
move the test.ps1 to /var/www/html in your linux machine and start a listener. I prefer python: "python3 -m http.server".
After it starts runnin' on port 8000, all you need to do is wait for the victim to execute the 'command-to-execute.ps1' of the repo. I love to use Argfuscator to first obfuscate it and then change the script into a base64 before testin' it on my lab windows.
