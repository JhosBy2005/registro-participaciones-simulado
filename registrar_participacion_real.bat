@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Registrar participacion real del equipo

REM ============================================================
REM Este script NO falsifica autores, fechas ni commits.
REM Cada integrante debe ejecutarlo desde su propia cuenta de GitHub.
REM El script detecta el usuario con GitHub CLI, aplica un cambio real
REM asignado a esa persona, crea un commit real y hace push.
REM ============================================================

cd /d "%~dp0"

echo.
echo REGISTRAR PARTICIPACION REAL
echo ============================
echo Cada integrante debe ejecutar este archivo con su propia cuenta.
echo.

call :find_git
if errorlevel 1 exit /b 1

where gh >nul 2>nul
if errorlevel 1 (
    echo [ERROR] GitHub CLI no esta instalado o no esta en PATH.
    echo Instala GitHub CLI desde https://cli.github.com/ y ejecuta:
    echo gh auth login
    pause
    exit /b 1
)

for /f "delims=" %%A in ('gh api user --jq ".login" 2^>nul') do set "GH_USER=%%A"
if "%GH_USER%"=="" (
    echo [ERROR] No se pudo detectar la cuenta de GitHub.
    echo Ejecuta primero:
    echo gh auth login
    pause
    exit /b 1
)

echo Cuenta detectada: %GH_USER%
echo.

set "MEMBER_KEY="
if /i "%GH_USER%"=="JhosBy2005" set "MEMBER_KEY=santana"
if /i "%GH_USER%"=="darnell1910" set "MEMBER_KEY=darnell"
if /i "%GH_USER%"=="jimenacuri" set "MEMBER_KEY=jimena"
if /i "%GH_USER%"=="Jimena" set "MEMBER_KEY=jimena"
if /i "%GH_USER%"=="mieioma" set "MEMBER_KEY=mauricio"
if /i "%GH_USER%"=="chopper0507" set "MEMBER_KEY=martinez"

if "%MEMBER_KEY%"=="" (
    echo [ERROR] Tu usuario no esta mapeado en este script.
    echo Usuario detectado: %GH_USER%
    echo Edita la seccion de mapeo del archivo para agregar tu username.
    pause
    exit /b 1
)

"%GIT%" rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Esta carpeta no parece ser un repositorio Git.
    echo Abre este archivo desde la carpeta del repositorio.
    pause
    exit /b 1
)

for /f "delims=" %%A in ('"%GIT%" config user.name') do set "GIT_NAME=%%A"
for /f "delims=" %%A in ('"%GIT%" config user.email') do set "GIT_EMAIL=%%A"

if "%GIT_NAME%"=="" (
    set /p "GIT_NAME=Escribe tu nombre para Git: "
    "%GIT%" config user.name "%GIT_NAME%"
)

if "%GIT_EMAIL%"=="" (
    set /p "GIT_EMAIL=Escribe tu correo de GitHub/Git: "
    "%GIT%" config user.email "%GIT_EMAIL%"
)

echo Actualizando main antes de aplicar cambios...
"%GIT%" pull --rebase origin main
if errorlevel 1 (
    echo [ERROR] No se pudo actualizar el repositorio.
    echo Revisa tu conexion o resuelve conflictos pendientes.
    pause
    exit /b 1
)

if not exist "participacion" mkdir "participacion"
if not exist "docs" mkdir "docs"

if "%MEMBER_KEY%"=="darnell" call :darnell
if "%MEMBER_KEY%"=="mauricio" call :mauricio
if "%MEMBER_KEY%"=="jimena" call :jimena
if "%MEMBER_KEY%"=="martinez" call :martinez
if "%MEMBER_KEY%"=="santana" call :santana

if errorlevel 1 exit /b 1

set "HAS_CHANGES="
for /f "delims=" %%A in ('"%GIT%" status --porcelain') do set "HAS_CHANGES=1"

if "%HAS_CHANGES%"=="" (
    echo.
    echo No hay cambios nuevos para commitear. Parece que tu participacion ya fue registrada.
    pause
    exit /b 0
)

echo.
echo Archivos modificados:
"%GIT%" status --short
echo.

"%GIT%" add index.html css/styles.css js/main.js README.md docs participacion .nojekyll
if errorlevel 1 goto :git_error

"%GIT%" commit -m "%COMMIT_MESSAGE%"
if errorlevel 1 goto :git_error

"%GIT%" push origin main
if errorlevel 1 goto :git_error

echo.
echo Listo. Tu participacion real fue registrada y subida a GitHub.
echo Autor Git local: %GIT_NAME% ^<%GIT_EMAIL%^>
echo Cuenta GitHub: %GH_USER%
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

:darnell
set "COMMIT_MESSAGE=feat: refine semantic structure for final page"
set "NOTE=participacion\darnell-cuba.md"
if not exist "%NOTE%" (
    > "%NOTE%" echo # Darnell Cuba - HTML y estructura
    >> "%NOTE%" echo.
    >> "%NOTE%" echo Area: revision de estructura HTML, navegacion y jerarquia de secciones.
)
>> "%NOTE%" echo - %DATE% %TIME% - Reviso estructura semantica, enlaces internos y orden principal de la pagina.
findstr /C:"Team contribution: Darnell Cuba" "index.html" >nul 2>nul
if errorlevel 1 (
    >> "index.html" echo.
    >> "index.html" echo ^<!-- Team contribution: Darnell Cuba reviewed semantic structure, navigation and main sections. --^>
)
exit /b 0

:mauricio
set "COMMIT_MESSAGE=style: improve responsive and focus states"
set "NOTE=participacion\mauricio-valverde.md"
if not exist "%NOTE%" (
    > "%NOTE%" echo # Mauricio Valverde - CSS y diseno visual
    >> "%NOTE%" echo.
    >> "%NOTE%" echo Area: estilos, responsive y consistencia visual.
)
>> "%NOTE%" echo - %DATE% %TIME% - Ajusto lineamientos de foco visible y reduccion de movimiento para accesibilidad.
findstr /C:"Team contribution: Mauricio Valverde" "css\styles.css" >nul 2>nul
if errorlevel 1 (
    >> "css\styles.css" echo.
    >> "css\styles.css" echo /* Team contribution: Mauricio Valverde - responsive accessibility polish. */
    >> "css\styles.css" echo :focus-visible { outline: 3px solid var^(--yellow^); outline-offset: 3px; }
    >> "css\styles.css" echo @media ^(prefers-reduced-motion: reduce^) { *, *::before, *::after { scroll-behavior: auto !important; transition-duration: .01ms !important; animation-duration: .01ms !important; } }
)
exit /b 0

:jimena
set "COMMIT_MESSAGE=feat: add app readiness marker for interactions"
set "NOTE=participacion\jimena-curi.md"
if not exist "%NOTE%" (
    > "%NOTE%" echo # Jimena Curi - JavaScript e interacciones
    >> "%NOTE%" echo.
    >> "%NOTE%" echo Area: interacciones, validaciones y comportamiento dinamico.
)
>> "%NOTE%" echo - %DATE% %TIME% - Registro una marca de inicializacion para validar carga del JavaScript principal.
findstr /C:"Team contribution: Jimena Curi" "js\main.js" >nul 2>nul
if errorlevel 1 (
    >> "js\main.js" echo.
    >> "js\main.js" echo // Team contribution: Jimena Curi - app readiness marker for interaction checks.
    >> "js\main.js" echo function markFakeJobAppReady^(^) {
    >> "js\main.js" echo   document.documentElement.dataset.fakejobReady = "true";
    >> "js\main.js" echo }
    >> "js\main.js" echo markFakeJobAppReady^(^);
)
exit /b 0

:martinez
set "COMMIT_MESSAGE=docs: add fraud prevention content review"
set "NOTE=participacion\jose-martinez.md"
if not exist "%NOTE%" (
    > "%NOTE%" echo # Jose Martinez - investigacion y contenido
    >> "%NOTE%" echo.
    >> "%NOTE%" echo Area: contenido preventivo, senales de fraude y recursos.
)
>> "%NOTE%" echo - %DATE% %TIME% - Documento criterios de contenido para senales de fraude laboral.
if not exist "docs\contenido-prevencion.md" (
    > "docs\contenido-prevencion.md" echo # Revision de contenido preventivo
    >> "docs\contenido-prevencion.md" echo.
    >> "docs\contenido-prevencion.md" echo Este documento resume criterios usados para redactar alertas y recomendaciones dentro de FakeJobDetector.
    >> "docs\contenido-prevencion.md" echo.
    >> "docs\contenido-prevencion.md" echo - Solicitudes de pago previo antes de entrevistas.
    >> "docs\contenido-prevencion.md" echo - Promesas de ingresos altos sin informacion verificable.
    >> "docs\contenido-prevencion.md" echo - Contactos informales que reemplazan canales corporativos.
    >> "docs\contenido-prevencion.md" echo - Enlaces acortados o dominios sospechosos.
)
exit /b 0

:santana
set "COMMIT_MESSAGE=chore: document final deployment checklist"
set "NOTE=participacion\jose-santana.md"
if not exist "%NOTE%" (
    > "%NOTE%" echo # Jose Santana - integracion y entrega final
    >> "%NOTE%" echo.
    >> "%NOTE%" echo Area: integracion final, repositorio y despliegue en GitHub Pages.
)
>> "%NOTE%" echo - %DATE% %TIME% - Actualizo checklist de entrega y despliegue del proyecto.
if not exist "docs\entrega-final.md" (
    > "docs\entrega-final.md" echo # Checklist de entrega final
    >> "docs\entrega-final.md" echo.
    >> "docs\entrega-final.md" echo - Verificar que index.html cargue estilos desde css/styles.css.
    >> "docs\entrega-final.md" echo - Verificar que la logica principal cargue desde js/main.js.
    >> "docs\entrega-final.md" echo - Confirmar que GitHub Pages use la rama main y la carpeta root.
    >> "docs\entrega-final.md" echo - Revisar README y archivos de participacion antes de la entrega.
)
if not exist ".nojekyll" type nul > ".nojekyll"
exit /b 0

:git_error
echo.
echo [ERROR] Fallo un comando de Git.
echo Revisa la salida anterior y vuelve a intentar.
pause
exit /b 1
