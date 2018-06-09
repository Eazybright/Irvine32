@ECHO OFF
CLS

REM makeLib.bat, by Kip Irvine
REM Last update: 6/1/2006

REM **** CAUTION: FOR ADVANCED USERS ONLY *****

REM Use this batch file after you have modified Irvine16.asm or floatio.asm. It assembles
REM both files, and inserts their OBJ files into the Irvine16.lib Library file.
REM Calls: ML.EXE and LIB.EXE
REM Assumes you have installed Microsoft Visual Studio 2005 or Visual C++ 2005 Express.

REM After running this file successfully, copy Irvine16.lib into your c:\Irvine folder.

SET MASM="C:\Program Files\Microsoft Visual Studio 8\VC\bin\"

%MASM%ML /nologo -c -omf -Fl -Zi irvine16.asm

if errorlevel 1 goto terminate

%MASM%ML /nologo -c -omf -Fl -Zi floatio.asm

if errorlevel 1 goto terminate

LIB Irvine16 -+Irvine16.obj,nul,Irvine16.lib

LIB Irvine16 -+floatio.obj,nul,Irvine16.lib

:terminate
pause