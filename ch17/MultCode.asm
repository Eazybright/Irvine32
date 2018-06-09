TITLE Multiple Code Segments      (MultCode.asm)

; This small model program contains multiple
; code segments.
; Last update: 06/01/2006

.model small,stdcall
.stack 100h
WriteString PROTO

.data
msg1 db "First Message",0dh,0ah,0
msg2 db "Second Message",0dh,0ah,"$"

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	
	mov	dx,OFFSET msg1
	call	WriteString	; NEAR call
	call	Display		; FAR call
	.exit
main ENDP

.code OtherCode
Display PROC FAR
	mov	ah,9
	mov	dx,offset msg2
	int	21h
    ret
Display ENDP
END main