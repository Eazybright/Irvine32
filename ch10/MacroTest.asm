; Macro Library Test               (MacroTest.asm)

; This program demonstrates various macros from
; the Macros.inc file.

INCLUDE Irvine32.inc
INCLUDE Macros.inc

NAME_SIZE = 50

.data
str1 BYTE NAME_SIZE DUP(0)
array DWORD 5 DUP(12345678h)

.code
main PROC
	call Clrscr
	mGotoxy 20,0
	mDumpMem OFFSET array,	\	; array offset
	  LENGTHOF array,	\		; number of units
	  TYPE array				; size of each unit

	mGotoxy 10,8
	mWrite "Please enter your first name: "
	mReadString str1

	mGotoxy 10,10
	mWrite "Your name is "
	mWriteString str1
	call  Crlf

	exit
main ENDP
END main