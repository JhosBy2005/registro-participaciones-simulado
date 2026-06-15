@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Invitar colaboradores a GitHub

REM ============================================================
REM Invita colaboradores reales a un repositorio de GitHub.
REM Requiere GitHub CLI: https://cli.github.com/
REM Antes de ejecutar: gh auth login
REM ============================================================

echo.
echo INVITAR COLABORADORES A GITHUB
echo ==============================
echo Este script envia invitaciones reales al repositorio.
echo Necesitas el USERNAME de GitHub de cada integrante.
echo.

where gh >nul 2>nul
if errorlevel 1 (
    echo [ERROR] GitHub CLI no esta instalado o no esta en PATH.
    echo Instala GitHub CLI desde:
    echo https://cli.github.com/
    echo.
    echo Luego ejecuta:
    echo gh auth login
    pause
    exit /b 1
)

gh auth status >nul 2>nul
if errorlevel 1 (
    echo [ERROR] No hay sesion activa en GitHub CLI.
    echo Ejecuta primero:
    echo gh auth login
    pause
    exit /b 1
)

set "DEFAULT_OWNER=JhosBy2005"
set "DEFAULT_REPO=registro-participaciones-simulado"

set /p "OWNER=Owner / usuario dueno del repo [%DEFAULT_OWNER%]: "
if "%OWNER%"=="" set "OWNER=%DEFAULT_OWNER%"

set /p "REPO=Nombre del repositorio [%DEFAULT_REPO%]: "
if "%REPO%"=="" set "REPO=%DEFAULT_REPO%"

echo.
echo Permiso que se dara a los colaboradores:
echo 1. Write / push ^(recomendado para trabajo en equipo^)
echo 2. Read / pull
choice /c 12 /n /m "Elige 1 o 2: "
if errorlevel 2 (
    set "PERMISSION=pull"
) else (
    set "PERMISSION=push"
)

echo.
echo Escribe los USERNAMES de GitHub. Si no tienes alguno, dejalo vacio.
echo.

set /p "U1=Darnell Cuba ^<darnellcuba2006@hotmail.com^> username: "
set /p "U2=Mauricio Valverde ^<mauricio.leoval@gmail.com^> username: "
set /p "U3=Jimena Curi ^<jimenacha.curi@gmail.com^> username: "
set /p "U4=Jose Martinez ^<jalonso.m.5.7@gmail.com^> username: "
set /p "U5=Jose Santana ^<santanapromaster@gmail.com^> username: "

echo.
echo Enviando invitaciones a %OWNER%/%REPO%...
echo.

call :invite "%U1%" "Darnell Cuba"
call :invite "%U2%" "Mauricio Valverde"
call :invite "%U3%" "Jimena Curi"
call :invite "%U4%" "Jose Martinez"
call :invite "%U5%" "Jose Santana"

echo.
echo Proceso terminado.
echo Los colaboradores deben aceptar la invitacion en GitHub o en su correo.
echo.
pause
exit /b 0

:invite
set "USERNAME=%~1"
set "DISPLAY_NAME=%~2"

if "%USERNAME%"=="" (
    echo [SKIP] %DISPLAY_NAME%: sin username.
    exit /b 0
)

echo Invitando a %DISPLAY_NAME% ^(%USERNAME%^)...
gh api -X PUT "repos/%OWNER%/%REPO%/collaborators/%USERNAME%" -f permission="%PERMISSION%" >nul

if errorlevel 1 (
    echo [ERROR] No se pudo invitar a %DISPLAY_NAME% ^(%USERNAME%^).
    echo         Revisa que el username exista y que tengas permisos de admin en el repo.
) else (
    echo [OK] Invitacion enviada a %DISPLAY_NAME% ^(%USERNAME%^).
)

exit /b 0
