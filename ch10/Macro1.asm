TITLE Macro Examples - 1            (Macro1.ASM)

; This program demonstrates the MACRO directive.

INCLUDE Irvine32.inc
INCLUDE macros.inc

mPutchar MACRO char
	push eax
	mov  al,char
	call WriteChar
	pop  eax
ENDM

mPrintChar MACRO char,count
LOCAL temp
.data
temp BYTE count DUP(&char),0
.code
	push	edx
	mov	edx,OFFSET temp
	call	WriteString
	pop	edx
ENDM

mWriteAt MACRO X,Y,literal
	mGotoxy X,Y
	mWrite literal
ENDM


mPromptInteger MACRO prompt,returnVal
	mWrite prompt
	call	ReadInt
	mov	returnVal,eax
ENDM
.data
minVal DWORD ?

.code
main PROC

	call	Clrscr
	mWriteAt 15,10,"Hi there"
	call	Crlf

;---------------------------------
	mPutchar 'A'

; Invoke the macro in a loop.
    mov   al,'A'
    mov   ecx,20
L1:
	mPutchar al
    inc   al
    Loop  L1

	exit
main ENDP
END main