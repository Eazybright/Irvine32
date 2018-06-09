TITLE Keyboard Display           (keybd.asm)

; This program displays keyboard scan codes
; and ASCII codes, using INT 16h.
; Last update: 06/01/2006

Include Irvine16.inc

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	call	ClrScr	; clear screen

L1:	mov	ah,10h	; keyboard input
	int	16h		; using BIOS
	call	DumpRegs	; look at AH, AL
	cmp	al,1Bh	; ESC key pressed?
	jne	L1		; no: repeat the loop

	call	ClrScr	; clear screen
	
	exit
main ENDP
END main