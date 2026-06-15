@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Registrar integracion con coautores

REM ============================================================
REM Crea un commit real de integracion final con trailers
REM Co-authored-by para acreditar colaboracion real del equipo.
REM
REM Este script NO falsifica autores, NO cambia fechas y NO crea
REM commits como si otras personas los hubieran hecho.
REM Usalo solo si los integrantes realmente participaron en el trabajo.
REM ============================================================

cd /d "%~dp0"

echo.
echo REGISTRAR INTEGRACION CON COAUTORES
echo ===================================
echo Este commit quedara hecho por la cuenta configurada en Git.
echo Los demas integrantes apareceran como coautores si sus correos
echo estan vinculados/verificados en GitHub.
echo.

call :find_git
if errorlevel 1 exit /b 1

"%GIT%" rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Esta carpeta no parece ser un repositorio Git.
    pause
    exit /b 1
)

if not exist "docs" mkdir "docs"

set "DOC=docs\integracion-final-equipo.md"

> "%DOC%" echo # Integracion final del equipo
>> "%DOC%" echo.
>> "%DOC%" echo Este documento resume la participacion declarada para la integracion final de FakeJobDetector.
>> "%DOC%" echo.
>> "%DOC%" echo ## Integrantes
>> "%DOC%" echo.
>> "%DOC%" echo - Darnell Cuba ^<darnellcuba2006@hotmail.com^>: estructura HTML, navegacion y secciones principales.
>> "%DOC%" echo - Mauricio Valverde ^<mauricio.leoval@gmail.com^>: estilos, responsive y consistencia visual.
>> "%DOC%" echo - Jimena Curi ^<jimenacha.curi@gmail.com^>: JavaScript, validaciones e interacciones.
>> "%DOC%" echo - Jose Martinez ^<jalonso.m.5.7@gmail.com^>: contenido, investigacion y senales de fraude.
>> "%DOC%" echo - Jose Santana ^<santanapromaster@gmail.com^>: integracion final, repositorio y despliegue.
>> "%DOC%" echo.
>> "%DOC%" echo ## Alcance de integracion
>> "%DOC%" echo.
>> "%DOC%" echo - Separacion de la pagina final en HTML, CSS y JavaScript.
>> "%DOC%" echo - Preparacion para despliegue con GitHub Pages.
>> "%DOC%" echo - Revision de navegacion, formularios, analisis de ofertas e historial.
>> "%DOC%" echo - Documentacion del equipo y de la entrega final.
>> "%DOC%" echo.
>> "%DOC%" echo Generado: %DATE% %TIME%

echo.
echo Se actualizo %DOC%
echo.

set "HAS_CHANGES="
for /f "delims=" %%A in ('"%GIT%" status --porcelain') do set "HAS_CHANGES=1"

if "%HAS_CHANGES%"=="" (
    echo No hay cambios nuevos para commitear.
    pause
    exit /b 0
)

"%GIT%" add "%DOC%" README.md index.html css js assets .nojekyll registrar_integracion_con_coautores.bat
if errorlevel 1 goto :git_error

"%GIT%" commit ^
  -m "docs: document final team integration" ^
  -m "Co-authored-by: Darnell Cuba <darnellcuba2006@hotmail.com>" ^
  -m "Co-authored-by: Mauricio Valverde <mauricio.leoval@gmail.com>" ^
  -m "Co-authored-by: Jimena Curi <jimenacha.curi@gmail.com>" ^
  -m "Co-authored-by: Jose Martinez <jalonso.m.5.7@gmail.com>" ^
  -m "Co-authored-by: Jose Santana <santanapromaster@gmail.com>"
if errorlevel 1 goto :git_error

"%GIT%" push origin main
if errorlevel 1 goto :git_error

echo.
echo Listo. Se creo y subio un commit real con coautores.
echo Revisa GitHub; los coautores apareceran si los correos coinciden con sus cuentas.
echo.
pause
exit /b 0

:find_git
set "GIT=git"
where git >nul 2>nul
if not errorlevel 1 exit /b 0

set "GIT="
for /d %%D in ("%LOCALAPPDATA%\GitHubDesktop\app-*") do (
    if exist "%%~fD\resources\app\git\cmd\git.exe" set "GIT=%%~fD\resources\app\git\cmd\git.exe"
    if exist "%%~fD\resources\app\git\mingw64\bin\git.exe" set "GIT=%%~fD\resources\app\git\mingw64\bin\git.exe"
)

if "%GIT%"=="" (
    echo [ERROR] Git no esta instalado o no esta disponible.
    echo Instala Git para Windows desde https://git-scm.com/download/win
    echo o abre el repositorio con GitHub Desktop.
    pause
    exit /b 1
)

exit /b 0

:git_error
echo.
echo [ERROR] Fallo un comando de Git.
echo Revisa la salida anterior. Es posible que debas hacer Pull origin en GitHub Desktop.
pause
exit /b 1
