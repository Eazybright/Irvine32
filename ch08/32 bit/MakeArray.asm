; (MakeArray.asm)

; This program creates an array on the local variables 
; area of the stack.

INCLUDE Irvine32.inc

.data
count = 100
array WORD count DUP(?)

.code
main PROC

	call	makeArray
	mov	eax,0

	exit

main ENDP


makeArray PROC
	push	ebp
	mov	ebp,esp
	sub	esp,32				; myString is at EBP-32

	lea	esi,[ebp-32]		; load address of myString
	mov	ecx,30				; loop counter
L1:	mov	BYTE PTR [esi],'*'	; fill one position
	inc	esi					; move to next
	loop	L1				; continue until ECX = 0

	add	esp,32				; remove the array (restore ESP)
	pop	ebp
	ret
makeArray ENDP

END main

