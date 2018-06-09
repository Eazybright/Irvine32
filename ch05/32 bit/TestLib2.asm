; Link Library Test #2	(TestLib2.asm)

; Testing the Irvine32 Library procedures.

INCLUDE Irvine32.inc

TAB = 9		; ASCII code for Tab

.code
main PROC
	call	Randomize		; init random generator
	call	Rand1
	call	Rand2
	exit
main ENDP

Rand1 PROC
; Generate ten pseudo-random integers.
	mov	ecx,10		; loop 10 times
	
L1:	call	Random32		; generate random int
	call	WriteDec		; write in unsigned decimal
	mov	al,TAB		; horizontal tab
	call	WriteChar		; write the tab
	loop	L1

	call	Crlf
	ret
Rand1 ENDP

Rand2 PROC
; Generate ten pseudo-random integers between -50 and +49
	mov	ecx,10		; loop 10 times
	
L1:	mov	eax,100		; values 0-99
	call	RandomRange	; generate random int
	sub	eax,50		; vaues -50 to +49
	call	WriteInt		; write signed decimal
	mov	al,TAB		; horizontal tab
	call	WriteChar		; write the tab
	loop	L1

	call	Crlf
	ret
Rand2 ENDP

END main