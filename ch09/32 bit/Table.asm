; Two-Dimensional Table                (Table.asm)

; Demonstration of Base-Index mode with a
; two-dimensional table.

INCLUDE Irvine32.inc

.data
tableB  BYTE  10h,  20h,  30h,  40h,  50h
        BYTE  60h,  70h,  80h,  90h, 0A0h
        BYTE  0B0h, 0C0h, 0D0h, 0E0h, 0F0h
RowSize = 5

.code
main PROC

; Demonstrate Base-Index mode:

   mov  ebx,OFFSET tableB
   add  ebx,RowSize
   mov  esi,2				; column number
   mov  al,[ebx + esi]		; AL = 80h

; Calculate sum of row 1:

	RowNum = 1
	mov  ecx,RowSize
	mov  ebx,OFFSET tableB
	add  ebx,(RowSize * RowNum)	; move to row 1
	mov  esi,0					; beginning of row
	mov  ax,0					; zero the sum
	mov  dx,0					; holds each value

L1:
	mov   dl,[ebx + esi]		; get a byte
	add   ax,dx					; add to accumulator
	inc   esi
	loopd L1

; AX = 280h, the sum

	exit
main ENDP
END main