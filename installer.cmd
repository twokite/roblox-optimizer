@echo off
setlocal enabledelayedexpansion

echo.
echo Starting installation...
echo.

set "folders="

rem === Check Bloxstrap Installation ===
if exist "%localappdata%\Bloxstrap\Modifications" (
    if exist "%localappdata%\Bloxstrap\Bloxstrap.exe" (
        echo Bloxstrap was found during installation.
        echo.
        set "folders=%localappdata%\Bloxstrap\Modifications"
    )
)

rem === Check Roblox Installations ===
for /d %%i in ("%localappdata%\Roblox\Versions\*") do call :CheckRobloxDir "%%i"
for /d %%i in ("C:\Program Files (x86)\Roblox\Versions\*") do call :CheckRobloxDir "%%i"
for /d %%i in ("C:\Program Files\Roblox\Versions\*") do call :CheckRobloxDir "%%i"

rem === Exit if no folders found ===
if not defined folders (
    echo.
    echo ERROR: No valid Roblox installations found!
    echo.
    pause
    goto :EOF
)

rem === Loop through each folder safely ===
setlocal enabledelayedexpansion
set "safeFolders=!folders:;=","!"
for %%F in ("!safeFolders!") do (
    set "currentFolder=%%~F"
    call :ApplyToFolder
)


goto :AfterApply

rem === Function: Check Roblox Directory ===
:CheckRobloxDir
set "dir=%~1"
if exist "%dir%\RobloxPlayerBeta.dll" (
    echo Found valid directory: %dir%
    if not defined folders (
        set "folders=%dir%"
    ) else (
        set "folders=!folders!;%dir%"
    )
)
goto :EOF

rem === Function: Apply Settings ===
:ApplyToFolder
echo.
echo Applying settings to: !currentFolder!

if not exist "!currentFolder!\ClientSettings" (
    mkdir "!currentFolder!\ClientSettings"
)

rem === Download ClientAppSettings.json ===
powershell.exe -Command ^
    "try {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/ClientAppSettings.json', '!currentFolder!\ClientSettings\ClientAppSettings.json')} catch {exit 1}"

if errorlevel 1 (
    echo ERROR: Failed to download ClientAppSettings.json
    goto :EOF
)

rem === Download Roblox.zip ===
powershell.exe -Command ^
    "try {(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/twokite/roblox-optimizer/main/Roblox.zip', '!currentFolder!\Roblox.zip')} catch {exit 1}"

if errorlevel 1 (
    echo ERROR: Failed to download Roblox.zip
    goto :EOF
)

rem === Extract Roblox.zip ===
powershell.exe -Command ^
    "try {Expand-Archive -Path '!currentFolder!\Roblox.zip' -DestinationPath '!currentFolder!' -Force} catch {exit 1}"

if errorlevel 1 (
    echo ERROR: Failed to extract Roblox.zip
) else (
    echo SUCCESS: Applied to !currentFolder!
)

goto :EOF

:AfterApply
echo.
echo Press any key to continue...
pause >nul

endlocal
exit /b
