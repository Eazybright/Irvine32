; 64-bit Row Sum Calculation         (RowSum.asm)

Comment !
Tests the mCalc_row_sum macro.
!

ExitProcess PROTO
WriteHex64 PROTO
Crlf PROTO

;------------------------------------------------------------
mCalc_row_sum MACRO index, arrayOffset, rowSize, eltType
; Calculates the sum of a row in a two-dimensional array.
;
; Receives: row index, offset of the array, number of bytes
; in each table row, and the array type (BYTE, WORD, or DWORD).
; Returns: RAX = sum.
;-------------------------------------------------------------
LOCAL L1
	push rbx		; save changed regs
	push rcx
	push rsi

; set up the required registers
	mov rax,index
	mov rbx,arrayOffset
	mov rcx,rowSize

; calculate the row offset.
	mul rcx							; row index * row size
	add rbx,rax						; row offset

; prepare the loop counter.
	shr rcx,(TYPE eltType / 2)		; byte=0, word=1, dword=2

; initialize the accumulator and column indexes
	mov rax,0						; accumulator
	mov rsi,0						; column index

L1: 
	IFIDNI <eltType>, <DWORD>
		mov	  edx,eltType PTR[rbx + rsi*(TYPE eltType)]
	ELSE
		movzx edx,eltType PTR[rbx + rsi*(TYPE eltType)]
	ENDIF

	add rax,rdx						; add to accumulator
	inc rsi
	loop L1

	pop rsi							; restore changed regs
	pop rcx
	pop rbx
ENDM


.data
tableB BYTE 10h, 20h, 30h, 40h, 50h
RowSizeB = ($ - tableB)
	DWORD 60h, 70h, 80h, 90h, 0A0h
	DWORD 0B0h, 0C0h, 0D0h, 0E0h, 0F0h

tableW WORD 10h, 20h, 30h, 40h, 50h
RowSizeW = ($ - tableW)
	DWORD 60h, 70h, 80h, 90h, 0A0h
	DWORD 0B0h, 0C0h, 0D0h, 0E0h, 0F0h

tableD DWORD 10h, 20h, 30h, 40h, 50h
RowSizeD = ($ - tableD)
	DWORD 60h, 70h, 80h, 90h, 0A0h
	DWORD 0B0h, 0C0h, 0D0h, 0E0h, 0F0h

index QWORD ?


.code
main PROC

; Demonstrate Base-Index mode:

	mCalc_row_sum index, OFFSET tableB, RowSizeB, BYTE
	call  WriteHex64
	call  Crlf

	mCalc_row_sum index, OFFSET tableW, RowSizeW, WORD
	call  WriteHex64
	call  Crlf

	mCalc_row_sum index, OFFSET tableD, RowSizeD, DWORD
	call  WriteHex64
	call  Crlf

		mov   ecx,0			; assign a process return code
	call  ExitProcess	; terminate the program
main ENDP

END 