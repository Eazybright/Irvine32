; Multiply an Array                (Mult.asm)

; This program multiplies each element of an array
; of 32-bit integers by a constant value.

INCLUDE Irvine32.inc

.data
array DWORD 1,2,3,4,5,6,7,8,9,10	; test data
multiplier DWORD 10				; test data

.code
main PROC
	cld 						; direction = up
	mov	esi,OFFSET array  		; source index
	mov	edi,esi				; destination index
	mov	ecx,LENGTHOF array		; loop counter

L1:	lodsd                   		; copy [ESI] into EAX
	mul	multiplier			; multiply by a value
	stosd                   		; store EAX at [EDI]
	loop L1

	exit
main ENDP
END main