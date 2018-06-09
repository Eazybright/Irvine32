TITLE Hello Program in COM format   (HelloCom.asm)

.model tiny
.code
org 100h       	; must be before main
main PROC
	mov  ah,9
	mov  dx,OFFSET hello_message
	int  21h
	mov  ax,4C00h
	int  21h
main ENDP

hello_message BYTE 'Hello, world!',0dh,0ah,'$'

END main