@echo off
setlocal enabledelayedexpansion

echo.
echo Starting installation...
echo.

set "folders="

rem Check Bloxstrap installation
if exist "%localappdata%\Bloxstrap\Modifications" (
    if exist "%localappdata%\Bloxstrap\Bloxstrap.exe" (
        echo Bloxstrap was found during installation.
        echo.
        set "folders=%localappdata%\Bloxstrap\Modifications"
    )
)

rem Check Roblox installations
for /d %%i in (
    "%localappdata%\Roblox\Versions\*"
    "C:\Program Files (x86)\Roblox\Versions\*"
    "C:\Program Files\Roblox\Versions\*"
) do (
    if exist "%%i\RobloxPlayerBeta.dll" (
        if not defined folders (
            set "folders=%%i"
        ) else (
            set "folders=!folders!;%%i"
        )
    )
)

rem If no folders found, exit
if not defined folders (
    echo.
    echo ERROR: No valid Roblox installations found!
    echo.
    pause
    goto :EOF
)

rem Loop through each folder
for %%F in (!folders:;= !) do (
    echo.
    echo Applying settings to: %%F

    rem Create ClientSettings if not exist
    if not exist "%%F\ClientSettings" (
        mkdir "%%F\ClientSettings"
    )

    rem Download ClientAppSettings.json
    powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('%url%', '%%F\ClientSettings\ClientAppSettings.json')}"

    rem Download and extract Roblox.zip
    powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/Roblox.zip', '%%F\Roblox.zip')}"
    powershell.exe -Command "& {Expand-Archive -Path '%%F\Roblox.zip' -DestinationPath '%%F' -Force}"

    if !errorlevel! EQU 0 (
        echo.
        echo SUCCESS: Applied to %%F
    ) else (
        echo.
        echo ERROR: Failed to apply to %%F
    )
)

echo.
echo Press any key to continue...
pause >nul

rem Update installer script
powershell.exe -Command "& {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/installer.cmd', '%~f0')}"
