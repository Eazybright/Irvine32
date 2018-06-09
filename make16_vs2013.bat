@echo off
REM make16_vs2013.bat
REM Updated 6/21/2014, for Visual Studio 2013
REM By: Kip R. Irvine

REM Assembles and links the current 16-bit ASM program.
REM Assumes you have installed Microsoft Visual Studio 2013
REM or Visual Studio 2013 Express.
REM 
REM Command-line options (unless otherwise noted, they are case-sensitive):
REM 
REM -Cp     Enforce case-sensitivity for all identifiers
REM -Zi		Include source code line information for debugging
REM -Fl		Generate a listing file
REM /CODEVIEW   Generate CodeView debugging information (linker)
REM %1.asm      The name of the source file, passed on the command line

REM ************* The following lines can be customized:
SET MASM="C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\"
SET INCLUDE=C:\Irvine
SET LIB=C:\Irvine
REM **************************** End of customized lines

REM Invoke ML.EXE (the assembler):

%MASM%ML /nologo -c -omf -Fl -Zi %1.asm
if errorlevel 1 goto terminate

REM Run the 16-bit linker, modified for Visual Studio:

c:\Irvine\LINK16 %1,,NUL,Irvine16 /CODEVIEW;
if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR %1.*

:terminate
pause
