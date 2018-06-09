; ASCII Addition                      (ASCII_add.asm)

; This program performs ASCII arithmetic on digit strings having 
; implied fixed decimal points.

INCLUDE Irvine32.inc

DECIMAL_OFFSET = 5						; offset from right of string
.data
decimal_one BYTE "100123456789765"			; 1001234567.89765
decimal_two BYTE "900402076502015"			; 9004020765.02015
sum BYTE (SIZEOF decimal_one + 1) DUP(0),0

.code
main PROC

; Start at the last digit position.

	mov	esi,SIZEOF decimal_one - 1
	mov	edi,SIZEOF decimal_one
	mov	ecx,SIZEOF decimal_one
	mov	bh,0					; set carry value to zero

L1:	mov	ah,0					; clear AH before addition
	mov	al,decimal_one[esi]		; get the first digit
	add	al,bh				; add the previous carry	
	aaa						; adjust the sum (AH = carry)
	mov	bh,ah				; save the carry in carry1
	or	bh,30h				; convert it to ASCII
	add	al,decimal_two[esi]		; add the second digit
	aaa						; adjust the sum (AH = carry) 
	or	bh,ah				; OR the carry with carry1
	or	bh,30h				; convert it to ASCII
	or	al,30h				; convert AL back to ASCII
	mov	sum[edi],al			; save it in the sum
	dec	esi 					; back up one digit
	dec	edi
	loop	L1
	mov	sum[edi],bh			; save last carry digit

; Display the sum as a string.

	mov	edx,OFFSET sum
	call	WriteString
	call	Crlf
	
	exit
main ENDP
END main