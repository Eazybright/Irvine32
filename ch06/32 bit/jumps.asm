; Conditional Jumps             (jumps.asm)

; Demonstrates conditional jumps

INCLUDE irvine32.inc
.data
var1 DWORD 0

code segment 'CODE'
main PROC

	je	L1			; jump to short target
	mov  edx,offset var1	
L1:

	mov	ax,bx
	nop			; align next instruction
	mov	edx,ecx


	jz FarLabel
	nop	
	nop
	nop

	mov	ax,4C00h
	int	21h
main ENDP
code ends

other segment 'CODE'

FarLabel:
	


other ends




END main