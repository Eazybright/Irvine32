; Demonstrate reference parameters   (ArrayFill.asm)

; This program fills an array with 16-bit randomly generated integers.

INCLUDE Irvine32.inc

.data
count = 100
array WORD count DUP(?)

.code
main PROC

	push OFFSET array
	push COUNT
	call ArrayFill
	
	exit

main ENDP


ArrayFill PROC	
	push	ebp
	mov	ebp,esp
	pushad			; save registers
	mov	esi,[ebp+12]	; offset of array
	mov	ecx,[ebp+8]	; array size
	cmp	ecx,0		; ECX == 0?
	je	L2			; yes: skip over loop
    
L1:
	mov	eax,10000h	; get random 0 - FFFFh
	call	RandomRange	; from the link library
	mov	[esi],ax
	add	esi,TYPE WORD
	loop	L1

L2:	popad			; restore registers
	pop	ebp
	ret	8			; clean up the stack
ArrayFill ENDP

END main

