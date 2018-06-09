; Main module    (main.asm)

INCLUDE Irvine32.inc
INCLUDE vars.inc

.code
main PROC
	mov count,2000h
	mov eax,SYM1
	
main ENDP

END main