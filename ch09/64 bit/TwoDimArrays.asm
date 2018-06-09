; Two-dimensional arrays in 64-bit mode (TwoDimArrays.asm)

Crlf			proto
WriteInt64  proto
ExitProcess proto

.data
table QWORD 1,2,3,4,5
RowSize = ($ - table)
	  QWORD 6,7,8,9,10
     QWORD 11,12,13,14,15
   
.code
main proc
; base-index-displacement operands

	mov	rax,1					; row index (zero-based)
	mov	rsi,4					; column index (zero based)
	call	get_tableVal		; returns the value in RAX
	call	WriteInt64			; and display it
	call	Crlf

	mov   ecx,0			; assign a process return code
	call  ExitProcess	; terminate the program
main endp

;------------------------------------------------------
; get_tableVal
; Returns the array value at a given row and column
; in a two-dimensional array of quadwords.
; Receives: RAX = row number, RSI = column number
; Returns:  value in RAX
;------------------------------------------------------
get_tableVal proc uses rbx
	mov	rbx,RowSize
	mul	rbx				; product(low) = RAX
	mov	rax,table[rax + rsi*TYPE table]

	ret
get_tableVal endp


end
