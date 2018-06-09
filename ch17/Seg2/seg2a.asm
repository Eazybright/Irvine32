TITLE Segment Example       (submodule, SEG2A.ASM)

; External module for the Seg2 program. Build this program using
; the make16.bat file located in the same directory.
; Last update: 06/01/2006

PUBLIC subroutine_1, var2

cseg SEGMENT BYTE PUBLIC 'CODE'
ASSUME cs:cseg, ds:dseg

subroutine_1 PROC           ; called from MAIN
	mov ah,9
	mov dx,OFFSET msg
	int 21h
	ret
subroutine_1 ENDP
cseg ENDS

dseg SEGMENT WORD PUBLIC 'DATA'

var2 WORD 2000h                ; accessed by MAIN
msg  BYTE 'Now in Subroutine_1'
     BYTE 0Dh,0Ah,'$'

dseg ENDS
END