@echo off
REM make16.bat
REM Updated 1/1/2014
REM By: Kip R. Irvine

REM Special version of make16.bat used only for the HelloNew.asm 
REM program in Irvine Chapter 10.

REM Assumes you have installed Microsoft Visual Studio 2012,
REM or Visual C++ 2012 Express.

REM ************* The following lines can be customized:
SET MASM="C:\Program Files\Microsoft Visual Studio 11.0\VC\bin\"
SET INCLUDE=C:\Irvine
SET LIB=C:\Irvine
REM **************************** End of customized lines

REM Invoke ML.EXE (the assembler):

%MASM%ML /nologo -c -omf -Fl -Zi -DRealMode=1 HelloNew.asm
if errorlevel 1 goto terminate

REM Run the 16-bit linker, modified for Visual Studio.Net:

c:\Irvine\LINK16 HelloNew,,NUL,Irvine16;
if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR HelloNew.*

:terminate
pause
