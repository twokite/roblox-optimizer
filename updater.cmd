@echo off

set "destination=%USERPROFILE%\Downloads\installer.cmd"

echo Downloading latest file from GitHub...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/installer.cmd', '%destination%')"

start "" "%destination%"

exit
