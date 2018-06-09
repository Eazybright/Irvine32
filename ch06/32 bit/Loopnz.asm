; Scanning for a Positive Value        (Loopnz.asm)

; Scan an array for the first positive value.
; If no value is found, ESI will point to a sentinel
; value (0) stored immediately after the array.

INCLUDE Irvine32.inc
.data
array  SWORD  -3,-6,-1,-10,10,30,40,4
sentinel SWORD  0

.code
main PROC
	mov esi,OFFSET array
	mov ecx,LENGTHOF array

next:
	test WORD PTR [esi],8000h		; test sign bit
	pushfd						; push flags on stack
	add  esi,TYPE array
	popfd						; pop flags from stack
	loopnz next 					; continue loop
	
	jnz  quit						; none found
	sub  esi,TYPE array				; ESI points to value

quit:
	movsx eax,WORD PTR[esi]			; display the value
	call WriteInt
	call crlf
	exit
main ENDP

END main