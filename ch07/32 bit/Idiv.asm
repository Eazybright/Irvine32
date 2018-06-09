; IDIV Examples             (Idiv.asm)

; This program shows examples of various IDIV formats.

INCLUDE Irvine32.inc

.code
main PROC

; Example 1
.data
byteVal SBYTE -48
.code
	mov	al,byteVal	; dividend
	cbw				; extend AL into AH
	mov	bl,+5		; divisor
	idiv	bl			; AL = -9, AH = -3
	call	DumpRegs

; Example 2
.data
wordVal SWORD -5000
.code
	mov	ax,wordVal 	; dividend, low
	cwd               	; extend AX into DX
	mov	bx,+256		; divisor
	idiv	bx			; quotient AX = -19, rem DX = -136
	call	DumpRegs
	
; Example 3

.data
dwordVal SDWORD +50000
.code
	mov	eax,dwordVal 	; dividend, low
	cdq 				; extend EAX into EDX
	mov	ebx,-256		; divisor
	idiv	ebx          	; quotient EAX = -195, rem EDX = +80
	call	DumpRegs

	exit
main ENDP
END main