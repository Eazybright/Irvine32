; Demonstrate 8-bit stack argument    (Uppercase.asm)

; Last update: 06/01/2006

INCLUDE Irvine32.inc

.data
charVal	BYTE 'x'

.code
main PROC

;-------------------------------------------------
; Call the Uppercase procedure:
;-------------------------------------------------

	;push	charVal		; invalid 8-bit operand

	;push	'x'			; pushes 32-bit value
	
	movzx	eax,charVal	; move with extension
	push	eax
	
	call	Uppercase
	call	WriteChar
	call	Crlf

	exit
main ENDP


Uppercase PROC			; convert stack char arg to uppercase
	push	ebp
	mov	ebp,esp
	
	mov	al,[esp+8]	; AL = character
	cmp	al,'a'		; less than 'a'?
	jb	L1			; yes: do nothing
	cmp	al,'z'		; greater than 'z'?
	ja	L1			; yes: do nothing
	sub	al,32		; no: convert it
	
L1:	pop	ebp
	ret	4			; clean up the stack
Uppercase ENDP


END main