TITLE Row Sum Calculation               (RowSumMacro.asm)

Comment !
Tests the mCalc_row_sum macro.
!

INCLUDE Irvine32.inc

;------------------------------------------------------------
mCalc_row_sum MACRO index, arrayOffset, rowSize, eltType
; Calculates the sum of a row in a two-dimensional array.
;
; Receives: row index, offset of the array, number of bytes
; in each table row, and the array type (BYTE, WORD, or DWORD).
; Returns: EAX = sum.
;-------------------------------------------------------------
LOCAL L1
	push ebx ; save changed regs
	push ecx
	push esi

; set up the required registers
	mov eax,index
	mov ebx,arrayOffset
	mov ecx,rowSize

; calculate the row offset.
	mul ecx							; row index * row size
	add ebx,eax						; row offset

; prepare the loop counter.
	shr ecx,(TYPE eltType / 2) ; byte=0, word=1, dword=2

; initialize the accumulator and column indexes
	mov eax,0						; accumulator
	mov esi,0						; column index

L1: 
	IFIDNI <eltType>, <DWORD>
		mov	edx,eltType PTR[ebx + esi*(TYPE eltType)]
	ELSE
		movzx edx,eltType PTR[ebx + esi*(TYPE eltType)]
	ENDIF

	add eax,edx						; add to accumulator
	inc esi
	loop L1

	pop esi							; restore changed regs
	pop ecx
	pop ebx
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

index DWORD ?


.code
main PROC

; Demonstrate Base-Index mode:

	mCalc_row_sum index, OFFSET tableB, RowSizeB, BYTE
	call  WriteHex
	call  Crlf

	mCalc_row_sum index, OFFSET tableW, RowSizeW, WORD
	call  WriteHex
	call  Crlf

	mCalc_row_sum index, OFFSET tableD, RowSizeD, DWORD
	call  WriteHex
	call  Crlf

	exit
main ENDP





END main