@echo off

echo.
echo Starting installation...
echo.

set "folder="

rem Check Bloxstrap installation
if exist "%localappdata%\Bloxstrap\Modifications" (
    if exist "%localappdata%\Bloxstrap\Bloxstrap.exe" (
        echo Bloxstrap was found during installation, setting folder.
        echo.
        set "folder=%localappdata%\Bloxstrap\Modifications"
        goto :NextStep
    )
)

rem Check Roblox installations
for /d %%i in (
    "%localappdata%\Roblox\Versions\*"
    "C:\Program Files (x86)\Roblox\Versions\*"
    "C:\Program Files\Roblox\Versions\*"
) do (
    if exist "%%i\RobloxPlayerBeta.exe" (
        set "folder=%%i"
        goto :NextStep
    )
)

:NextStep
rem Verify folder was set
if not defined folder (
    echo.
    echo ERROR: Roblox installation not found!
    echo.
    pause
    goto :EOF
)

rem Create ClientSettings directory if it does not exist
if not exist "%folder%\ClientSettings" (
    mkdir "%folder%\ClientSettings"
)

rem Prompt for texture choice
set /p choice=Do you want the default roblox textures? (Y/N): 
set "choice=%choice:~0,1%"

rem Set download URL based on user choice
set "url=https://raw.githubusercontent.com/twokite/roblox-optimizer/main/ClientAppSettings.json"
if /i "%choice%" NEQ "Y" (
    echo.
    echo Due to a recent roblox update, you are forced to use textures.
    echo.
    echo Unfortunately, there is no fix for it currently, so until then you must use the main file.
)

rem Download ClientAppSettings.json
echo.
echo Downloading ClientAppSettings.json file...
powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('%url%', '%folder%\ClientSettings\ClientAppSettings.json')}"

rem Download and extract Roblox.zip
powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/Roblox.zip', '%folder%\Roblox.zip')}"
powershell.exe -Command "& {Expand-Archive -Path '%folder%\Roblox.zip' -DestinationPath '%folder%' -Force}"

rem Check if download was successful
if %errorlevel% EQU 0 (
    echo.
    echo ClientAppSettings.json downloaded successfully!
    echo.
    echo SUCCESS: Installation completed!
) else (
    echo.
    echo Failed to download ClientAppSettings.json.
    echo.
    echo ERROR: Installation failed!
)

echo.
echo Press any key to continue...
pause >nul

rem Update installer script
powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/installer.cmd', '%~f0')}"
