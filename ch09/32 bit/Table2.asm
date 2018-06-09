; Two-Dimensional Table                (Table2.asm)

; Demonstration of Base-Index-Displacement mode with a
; two-dimensional table.

INCLUDE Irvine32.inc

.data
tableB  BYTE  10h,  20h,  30h,  40h,  50h
        BYTE  60h,  70h,  80h,  90h, 0A0h
        BYTE  0B0h, 0C0h, 0D0h, 0E0h, 0F0h
RowSize = 5

.code
main PROC

	mov  ebx,RowSize
	mov  esi,2					; column number
	mov  al,tableB[ebx + esi]	; AL = 80h

	exit
main ENDP
END main