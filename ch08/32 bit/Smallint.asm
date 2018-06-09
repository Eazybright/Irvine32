; Demonstrate 16-bit stack parameter    (Smallint.asm)

; This program demonstrates the use of 16-bit stack parameters.

INCLUDE Irvine32.inc

.data
wordVal	WORD 1234h

.code
main PROC

	push	wordVal
	call	Smallint
	call	DumpRegs
	
	exit

main ENDP

; receives a 16-bit stack parameter. Uses STDCALL.

 PROC	
	push	ebp
	mov	eax,0
	mov	ebp,esp
	mov	ax,[ebp+8]	; get 16-bit parameter
	add	ax,ax		; double it, return in EAX
	pop	ebp
	ret	2			; clean up the stack
SmallInt ENDP

END main