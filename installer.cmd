@echo off

echo.
echo Starting installation...
echo.

if exist "%localappdata%\Bloxstrap\Modifications" (
    echo Bloxstrap was found during installation, setting folder.
    echo.

    set folder="%localappdata%\Bloxstrap\Modifications"
    goto :NextStep
)

for /d %%i in ("%localappdata%\Roblox\Versions\*") do (
    if exist "%%i\RobloxPlayerBeta.exe" (
        set folder=%%i
        goto :NextStep
    )
)

for /d %%i in ("C:\Program Files (x86)\Roblox\Versions\*") do (
    if exist "%%i\RobloxPlayerBeta.exe" (
        set folder=%%i
        goto :NextStep
    )
)

for /d %%i in ("C:\Program Files\Roblox\Versions\*") do (
    if exist "%%i\RobloxPlayerBeta.exe" (
        set folder=%%i
        goto :NextStep
    )
)

:NextStep
if not exist "%folder%\ClientSettings" (
    mkdir "%folder%\ClientSettings"
)

set /p choice=Do you want the default roblox textures? (Y/N): 
set "choice=%choice:~0,1%"
if /i "%choice%"=="Y" (
    powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/ClientAppSettings.json', '%folder%\ClientSettings\ClientAppSettings.json')}"
) else (
    echo.
    echo Due to a recent roblox update, you are forced to use textures.
    echo.
    echo Unfortunately there is no fix for it currently, so until then you must use the main file.
    powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/ClientAppSettings.json', '%folder%\ClientSettings\ClientAppSettings.json')}"
    :: powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/NoTextures.json', '%folder%\ClientSettings\ClientAppSettings.json')}"
)

echo.
echo Downloading ClientAppSettings.json file...
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

powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/installer.cmd', '%~f0')}"
