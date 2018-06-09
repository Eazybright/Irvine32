; Multiword procedure arguments    (Multiword.asm)

; This program demonstrates the passing of a 64-bit argument
; to a procedure.

INCLUDE Irvine32.inc

.data
longVal DQ 1234567800ABCDEFh

.code
main PROC

	push	DWORD PTR longVal + 4	; high
	push	DWORD PTR longVal		; low
	call	WriteHex64

	call	Crlf
	exit
main ENDP


; Displays a 64-bit integer in Hexadecimal

WriteHex64 PROC
	push	ebp
	mov	ebp,esp

	mov	eax,[ebp+12]	; high doubleword
	call	WriteHex
	mov	eax,[ebp+8]	; low doubleword
	call	WriteHex

	pop	ebp
	ret	8			; clean up the stack
WriteHex64 ENDP


END main 