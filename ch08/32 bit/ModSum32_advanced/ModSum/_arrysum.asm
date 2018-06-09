; ArraySum Procedure                 (_arrysum.asm)

INCLUDE sum.inc
.code
;-----------------------------------------------------
ArraySum PROC,
	ptrArray:PTR DWORD,	; pointer to array
	arraySize:DWORD	; size of array
;
; Calculates the sum of an array of 32-bit integers.
; Returns:  EAX = sum
;-----------------------------------------------------
	push ecx		; don't push EAX
	push esi

	mov  eax,0		; set the sum to zero
	mov  esi,ptrArray
	mov  ecx,arraySize
	cmp  ecx,0		; array size <= 0?
	jle  L2		; yes: quit

L1:	add  eax,[esi]		; add each integer to sum
	add  esi,4		; point to next integer
	loop L1		; repeat for array size

L2:	pop esi
	pop ecx		; return sum in EAX
	ret
ArraySum ENDP
END