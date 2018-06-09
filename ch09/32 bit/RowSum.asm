; Row Sum Calculation					(RowSum.asm)

; This program demonstrates the use of Base-Index addressing 
; with a two-dimensional table array of bytes (a byte matrix).

INCLUDE Irvine32.inc

.data
tableB  BYTE  10h,  20h,  30h,  40h,  50h
        BYTE  60h,  70h,  80h,  90h,  0A0h
        BYTE  0B0h, 0C0h, 0D0h, 0E0h, 0F0h
RowSize = 5
msg1	BYTE "Enter row number: ",0
msg2 BYTE "The sum is: ",0

.code
main PROC

; Demonstrate Base-Index mode:

	mov	  edx,OFFSET msg1			; "Enter row number:"
	call  WriteString
	call  Readint					; EAX = row number

	mov	  ebx,OFFSET tableB
	mov	  ecx,RowSize
	call  calc_row_sum				; EAX = sum
   
	mov	  edx,OFFSET msg2			; "The sum is:"
	call  WriteString
	call  WriteHex					; write sum in EAX
	call  Crlf

	exit
main ENDP


;------------------------------------------------------------
calc_row_sum PROC uses ebx ecx edx esi
;
; Calculates the sum of a row in a byte matrix.
; Receives: EBX = table offset, EAX = row index, 
;		    ECX = row size, in bytes.
; Returns:  EAX holds the sum.
;------------------------------------------------------------

	mul	 ecx			; row index * row size
	add	 ebx,eax		; row offset
	mov	 eax,0		; accumulator
	mov	 esi,0		; column index

L1:	movzx edx,BYTE PTR[ebx + esi]		; get a byte
	add	 eax,edx						; add to accumulator
	inc	 esi							; next byte in row
	loop L1

	ret
calc_row_sum ENDP

END main