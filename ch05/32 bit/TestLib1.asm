; Library Test #1: Integer I/O   (TestLib1.asm)

; Tests the Clrscr, Crlf, DumpMem, ReadInt, 
; SetTextColor, WaitMsg, WriteBin, WriteHex, 
; and WriteString procedures.

INCLUDE Irvine32.inc
.data
arrayD     DWORD 1000h,2000h,3000h
prompt1    BYTE "Enter a 32-bit signed integer: ",0
dwordVal   DWORD ?

.code
main PROC
; Set text color to yellow text on blue background:
	mov	eax,yellow + (blue * 16)
	call	SetTextColor
	call	Clrscr			; clear the screen

; Display the array using DumpMem.
	mov	esi,OFFSET arrayD	; starting OFFSET
	mov	ecx,LENGTHOF arrayD	; number of units in dwordVal
	mov	ebx,TYPE arrayD	; size of a doubleword
	call	DumpMem			; display memory
	call	Crlf				; new line

; Ask the user to input a signed decimal integer.
	mov	edx,OFFSET prompt1
	call	WriteString
	call	ReadInt			; input the integer
	mov	dwordVal,eax		; save in a variable

; Display the integer in decimal, hexadecimal, and binary.
	call	Crlf				; new line
	call	WriteInt			; display in signed decimal
	call	Crlf
	call	WriteHex			; display in hexadecimal
	call	Crlf
	call	WriteBin			; display in binary
	call	Crlf
	call	WaitMsg			; "Press any key..."

; Return console window to default colors.
	mov	eax,lightGray + (black * 16)
	call	SetTextColor
	call	Clrscr
	exit
main ENDP
END main