REM makeLib.bat - Rebuilds the Irvine32 Library

REM by Kip Irvine
REM Last update: 4/19/2011

REM Creates a link library from an OBJ file.
REM Instructions:
REM (1) Run the Visual Studio Command Prompt from the Start menu
REM (2) Navigate to this folder (\Examples\Lib32\Irvine32_Library)
REM (3) Run this batch file.

@ECHO OFF
cls

REM Assemble the source code.
ML -c -coff Irvine32.asm
if errorlevel 1 goto terminate

ML -c -coff floatio.asm
if errorlevel 1 goto terminate

LIB /SUBSYSTEM:CONSOLE Irvine32.obj floatio.obj
if errorlevel 1 goto terminate

:terminate
pause