; ArraySum Procedure             (_arrysum.asm)

INCLUDE Irvine32.inc
.code
ArraySum PROC
;
; Calculates the sum of an array of 32-bit integers.

; Receives:
;	ptrArray		; pointer to array
;	arraySize		; size of array (DWORD)
; Returns:  EAX = sum
;-----------------------------------------------------
ptrArray EQU [ebp+8]
arraySize EQU [ebp+12]

	enter	0,0
	push	ecx		; don't push EAX
	push	esi

	mov	eax,0		; set the sum to zero
	mov	esi,ptrArray
	mov	ecx,arraySize
	cmp	ecx,0		; array size <= 0?
	jle	L2		; yes: quit

L1:	add	eax,[esi]		; add each integer to sum
	add	esi,4		; point to next integer
	loop	L1		; repeat for array size

L2:	pop	esi
	pop	ecx		; return sum in EAX
	leave
	ret	8
ArraySum ENDP
END