; MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
myMessage BYTE "MASM program example",0dh,0ah,0


.code
main PROC
	call Clrscr  


	mov	 edx,offset myMessage
	call WriteString

	exit
main ENDP

END main