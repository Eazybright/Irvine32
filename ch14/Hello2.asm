; Hello World Program         (Hello2.asm)

.MODEL small
.STACK 100h
.386

.data
message BYTE "Hello, world!",0dh,0ah

.code
main PROC
	.STARTUP

	mov	ah,40h			; write to file/device
	mov	bx,1				; output handle
	mov	cx,SIZEOF message	; number of bytes
	mov	dx,OFFSET message	; addr of buffer
	int	21h

    .EXIT
main ENDP
END