; Extended Addition Example           (ExtAdd.asm)

; This program calculates the sum of two 8-byte integers.
; The integers are stored as arrays, with the least significant 
; byte stored at the lowest address value.

INCLUDE Irvine32.inc

.data
op1 BYTE 34h,12h,98h,74h,06h,0A4h,0B2h,0A2h
op2 BYTE 02h,45h,23h,00h,00h,87h,10h,80h

sum BYTE 9 dup(0) 	; = 0122C32B0674BB5736h

.code
main PROC

	mov	esi,OFFSET op1		; first operand
	mov	edi,OFFSET op2		; second operand
	mov	ebx,OFFSET sum		; sum operand
	mov	ecx,LENGTHOF op1   	; number of bytes
	call	Extended_Add

; Display the sum.
	
	mov  esi,OFFSET sum
	mov  ecx,LENGTHOF sum
	call	Display_Sum
	call Crlf
	
	exit
main ENDP

;--------------------------------------------------------
Extended_Add PROC
;
; Calculates the sum of two extended integers stored 
; as arrays of bytes.
; Receives: ESI and EDI point to the two integers,
; EBX points to a variable that will hold the sum, and
; ECX indicates the number of bytes to be added.
; Storage for the sum must be one byte longer than the
; input operands.
; Returns: nothing
;--------------------------------------------------------
	pushad
	clc                			; clear the Carry flag

L1:	mov	al,[esi]      			; get the first integer
	adc	al,[edi]      			; add the second integer
	pushfd              		; save the Carry flag
	mov	[ebx],al      			; store partial sum
	add	esi,1         			; advance all 3 pointers
	add	edi,1
	add	ebx,1
	popfd               		; restore the Carry flag
	loop	L1           			; repeat the loop

	mov	byte ptr [ebx],0		; clear high byte of sum
	adc	byte ptr [ebx],0		; add any leftover carry
	popad
	ret
Extended_Add ENDP

;-----------------------------------------------------------
Display_Sum PROC
;
; Displays a large integer that is stored in little endian 
; order (LSB to MSB). The output displays the array in 
; hexadecimal, starting with the most significant byte.
; Receives: ESI points to the array, ECX is the array size
; Returns: nothing
;-----------------------------------------------------------
	pushad
	
	; point to the last array element
	add esi,ecx
	sub esi,TYPE BYTE
	mov ebx,TYPE BYTE
	
L1:	mov  al,[esi]			; get an array byte
	call WriteHexB			; display it
	sub  esi,TYPE BYTE		; point to previous byte
	loop L1

	popad
	ret
Display_Sum ENDP


END main