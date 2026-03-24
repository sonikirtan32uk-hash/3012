@echo off
setlocal

set "PROJECT_ROOT=%~dp0"
if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

set "SITE_ROOT=%PROJECT_ROOT%\build_output"
if not exist "%SITE_ROOT%\web.config" set "SITE_ROOT=%PROJECT_ROOT%"

set "IIS_EXPRESS=C:\Program Files\IIS Express\iisexpress.exe"
if not exist "%IIS_EXPRESS%" set "IIS_EXPRESS=C:\Program Files (x86)\IIS Express\iisexpress.exe"

if not exist "%IIS_EXPRESS%" (
    echo IIS Express was not found.
    exit /b 1
)

echo Running site from: %SITE_ROOT%
echo URL: http://localhost:8085/
"%IIS_EXPRESS%" /path:"%SITE_ROOT%" /port:8085

endlocal
