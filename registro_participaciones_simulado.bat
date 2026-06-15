@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Registro simulado de participaciones

REM ============================================================
REM Registro SIMULADO de participaciones para un proyecto grupal.
REM Este archivo NO crea commits, NO cambia autores de Git y NO hace push.
REM Usalo como plan, ejemplo o anexo interno, no como historial Git real.
REM ============================================================

set "PROJECT_NAME=FakeJobDetector"
set "COURSE=IHC y Tecnologias Moviles - ciclo 202610"
set "REPORT_FILE=registro_participaciones_simulado.txt"

REM Edita estos datos con los integrantes reales si lo necesitas.
set "P1=Darnell Cuba"
set "P1_EMAIL=darnellcuba2006@hotmail.com"
set "P1_ROLE=HTML y estructura"
set "P2=Mauricio Valverde"
set "P2_EMAIL=mauricio.leoval@gmail.com"
set "P2_ROLE=CSS y diseno visual"
set "P3=Jimena Curi"
set "P3_EMAIL=jimenacha.curi@gmail.com"
set "P3_ROLE=JavaScript e interacciones"
set "P4=José Martinez"
set "P4_EMAIL=jalonso.m.5.7@gmail.com"
set "P4_ROLE=Investigacion y contenido"
set "P5=José Santana"
set "P5_EMAIL=santanapromaster@gmail.com"
set "P5_ROLE=Formularios y accesibilidad"

echo Generando %REPORT_FILE%...

> "%REPORT_FILE%" echo REGISTRO SIMULADO DE PARTICIPACIONES
>> "%REPORT_FILE%" echo =====================================
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo IMPORTANTE: Este documento es una simulacion. No representa historial Git real.
>> "%REPORT_FILE%" echo No debe presentarse como evidencia de commits reales ni de autoria real.
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo Proyecto: %PROJECT_NAME%
>> "%REPORT_FILE%" echo Curso: %COURSE%
>> "%REPORT_FILE%" echo Generado: %DATE% %TIME%
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo INTEGRANTES Y AREAS
>> "%REPORT_FILE%" echo -------------------
>> "%REPORT_FILE%" echo - %P1% ^<%P1_EMAIL%^>: %P1_ROLE%
>> "%REPORT_FILE%" echo - %P2% ^<%P2_EMAIL%^>: %P2_ROLE%
>> "%REPORT_FILE%" echo - %P3% ^<%P3_EMAIL%^>: %P3_ROLE%
>> "%REPORT_FILE%" echo - %P4% ^<%P4_EMAIL%^>: %P4_ROLE%
>> "%REPORT_FILE%" echo - %P5% ^<%P5_EMAIL%^>: %P5_ROLE%
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo DETALLE SIMULADO POR SEMANA
>> "%REPORT_FILE%" echo ---------------------------
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 1 - 2026-04-01 al 2026-04-07
>> "%REPORT_FILE%" echo 01. 2026-04-01 09:18 - %P1% - feat: define landing page structure and header sections
>> "%REPORT_FILE%" echo 02. 2026-04-01 21:42 - %P3% - chore: add base script file and interaction placeholders
>> "%REPORT_FILE%" echo 03. 2026-04-02 16:10 - %P2% - style: create initial color palette and typography rules
>> "%REPORT_FILE%" echo 04. 2026-04-04 11:35 - %P4% - docs: draft problem statement and target user notes
>> "%REPORT_FILE%" echo 05. 2026-04-06 19:28 - %P1% - feat: add hero content and main navigation links
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 2 - 2026-04-08 al 2026-04-14
>> "%REPORT_FILE%" echo 06. 2026-04-08 08:52 - %P5% - feat: add contact form fields and labels
>> "%REPORT_FILE%" echo 07. 2026-04-09 22:16 - %P3% - feat: implement mobile menu toggle behavior
>> "%REPORT_FILE%" echo 08. 2026-04-10 15:33 - %P2% - style: refine spacing for cards and section layout
>> "%REPORT_FILE%" echo 09. 2026-04-12 10:44 - %P4% - docs: add fake job warning signs content
>> "%REPORT_FILE%" echo 10. 2026-04-13 20:07 - %P3% - fix: prevent empty form submission in demo flow
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 3 - 2026-04-15 al 2026-04-21
>> "%REPORT_FILE%" echo 11. 2026-04-15 17:21 - %P1% - feat: create results section for job analysis output
>> "%REPORT_FILE%" echo 12. 2026-04-16 23:04 - %P3% - feat: add keyword scoring logic for suspicious listings
>> "%REPORT_FILE%" echo 13. 2026-04-18 12:12 - %P5% - fix: improve form focus states and required field hints
>> "%REPORT_FILE%" echo 14. 2026-04-19 18:39 - %P2% - style: adjust responsive grid for tablet screens
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 4 - 2026-04-22 al 2026-04-28
>> "%REPORT_FILE%" echo 15. 2026-04-22 09:41 - %P4% - docs: add user persona summary and scenario notes
>> "%REPORT_FILE%" echo 16. 2026-04-23 21:25 - %P2% - style: polish buttons and interactive states
>> "%REPORT_FILE%" echo 17. 2026-04-25 14:58 - %P1% - refactor: reorganize page sections for clearer reading order
>> "%REPORT_FILE%" echo 18. 2026-04-26 22:31 - %P3% - fix: handle pasted multiline job descriptions
>> "%REPORT_FILE%" echo 19. 2026-04-28 11:09 - %P5% - feat: add accessible error messages for form validation
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 5 - 2026-04-29 al 2026-05-05
>> "%REPORT_FILE%" echo 20. 2026-04-29 20:18 - %P3% - refactor: simplify scoring thresholds and result labels
>> "%REPORT_FILE%" echo 21. 2026-05-01 10:36 - %P2% - style: improve mobile spacing and footer contrast
>> "%REPORT_FILE%" echo 22. 2026-05-02 16:49 - %P4% - docs: update references and presentation notes
>> "%REPORT_FILE%" echo 23. 2026-05-04 08:57 - %P1% - fix: align navigation anchors with page sections
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo SEMANA 6 - 2026-05-06 al 2026-05-12
>> "%REPORT_FILE%" echo 24. 2026-05-06 19:44 - %P5% - fix: improve keyboard navigation through form controls
>> "%REPORT_FILE%" echo 25. 2026-05-07 13:22 - %P2% - style: add final visual adjustments for presentation
>> "%REPORT_FILE%" echo 26. 2026-05-09 22:03 - %P3% - fix: tune risk messages for edge cases
>> "%REPORT_FILE%" echo 27. 2026-05-11 09:26 - %P4% - docs: prepare final project summary and conclusions
>> "%REPORT_FILE%" echo 28. 2026-05-12 18:15 - %P1% - chore: organize final files for delivery
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo RESUMEN SIMULADO POR INTEGRANTE
>> "%REPORT_FILE%" echo -------------------------------
>> "%REPORT_FILE%" echo - %P1% ^<%P1_EMAIL%^>: 6 participaciones simuladas
>> "%REPORT_FILE%" echo - %P2% ^<%P2_EMAIL%^>: 6 participaciones simuladas
>> "%REPORT_FILE%" echo - %P3% ^<%P3_EMAIL%^>: 7 participaciones simuladas
>> "%REPORT_FILE%" echo - %P4% ^<%P4_EMAIL%^>: 5 participaciones simuladas
>> "%REPORT_FILE%" echo - %P5% ^<%P5_EMAIL%^>: 4 participaciones simuladas
>> "%REPORT_FILE%" echo.
>> "%REPORT_FILE%" echo TOTAL: 28 participaciones simuladas

echo.
echo Listo. Archivo generado:
echo %CD%\%REPORT_FILE%
echo.
echo Recuerda: es un registro simulado, no historial Git real.
pause
exit /b 0
