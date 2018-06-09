; Testing ReadKey             (TestReadkey.asm)


INCLUDE Irvine32.inc
INCLUDE Macros.inc

.code
main PROC

L1:	mov	eax,10	; delay for msg processing
	call	Delay
	call	ReadKey	; wait for a keypress
	jz	L1

	test	ebx,CAPSLOCK_ON	
	jz	L2
	mWrite <"CapsLock is ON",0dh,0ah>
	jmp	L3

L2:	mWrite <"CapsLock is OFF",0dh,0ah>

L3:	exit
main ENDP
END main