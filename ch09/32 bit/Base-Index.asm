; Two-Dimensional Table                (Base-Index.asm)

; This program uses Base-Index and Base-index-displacement 
; modes to access two-dimensional arrays. 


INCLUDE Irvine32.inc

.data
tableB  BYTE   10h,  20h,  30h,  40h,  50h
Rowsize = ($ - tableB)
        BYTE   60h,  70h,  80h,  90h, 0A0h
        BYTE  0B0h, 0C0h, 0D0h, 0E0h, 0F0h

tableW  WORD   10h,  20h,  30h,  40h,  50h
RowsizeW = ($ - tableW)
        WORD   60h,  70h,  80h,  90h, 0A0h
        WORD  0B0h, 0C0h, 0D0h, 0E0h, 0F0h
        
tableD DWORD 10000h,   20000h,  30000h,  40000h,  50000h
RowSizeD = ($ - tableD)
	  DWORD 60000h,   70000h,  80000h,  90000h, 0A0000h
       DWORD 0B0000h, 0C0000h, 0D0000h, 0E0000h, 0F0000h
        
.code
main PROC

; Demonstrate Base-Index mode with the byte array:

row_index = 1
column_index = 2

	mov	ebx,OFFSET tableB		; table offset
	add	ebx,RowSize * row_index	; row offset
	mov	esi,column_index
	mov	al,[ebx + esi]			; AL = 80h

call	DumpRegs					; look at AL
	
; Demonstrate Base-Index mode with the word array:

row_index = 1
column_index = 2

	mov	ebx,OFFSET tableW			; table offset
	add	ebx,RowSizeW * row_index		; row offset
	mov	esi,column_index
	mov	ax,[ebx + esi*TYPE tableW]	; AX = 0080h

	call	DumpRegs					; look at AX
	
; Demonstrate Base-index-displacement mode with the doubleword
; array. Use a procedure call to get a value:	
	
	mov	eax,2		; row index
	mov	esi,4		; column index
	call	get_tableDval	; get the value
	call	WriteHex		; display EAX
	call	Crlf
	
	exit
main ENDP

;------------------------------------------------------
get_tableDval PROC uses ebx
;
; Returns the array value at a given row and column
; in tableD, a two-dimensional array of doublewords.
;
; Receives: EAX = row number, ESI = column number
; Returns:  value in EAX
;------------------------------------------------------

	mov	ebx,RowSizeD
	mul	ebx							; EAX = row offset
	mov	eax,tableD[eax + esi*TYPE tableD]

	ret
get_tableDval ENDP


END main