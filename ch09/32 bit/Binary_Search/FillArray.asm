TITLE FillArray Procedure                 (FillArray.asm)

INCLUDE Irvine32.inc

.code
;------------------------------------------------------------
FillArray PROC USES eax edi ecx edx,
	pArray:PTR DWORD,		  ; pointer to array
	Count:DWORD,		       ; number of elements
	LowerRange:SDWORD,		  ; lower range
	UpperRange:SDWORD		  ; upper range
;
; Fills an array with a random sequence of 32-bit signed
; integers between LowerRange and (UpperRange - 1).
; Returns: nothing
;-----------------------------------------------------------
	mov	edi,pArray	           ; EDI points to the array
	mov	ecx,Count	                ; loop counter
	mov	edx,UpperRange
	sub	edx,LowerRange	           ; EDX = absolute range (0..n)
	cld                            ; clear direction flag

L1:	mov	eax,edx	                ; get absolute range
	call	RandomRange
	add	eax,LowerRange	           ; bias the result
	stosd		                ; store EAX into [edi]
	loop	L1

	ret
FillArray ENDP

END