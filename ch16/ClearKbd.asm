TITLE Testing ClearKeyboard       (ClearKbd.asm)

; This program shows how to clear the keyboard
; buffer, while waiting for a particular key.
; To test it, rapidly press random keys to fill
; up the buffer. When you press Esc, the program 
; ends immediately.
; Last update: 06/01/2006

INCLUDE Irvine16.inc
ClearKeyboard PROTO, scanCode:BYTE
ESC_key = 1			; scan code

.code
main PROC
L1:	;------------------------- LOOP BODY
	; Display a dot, to show program's progress
	mov	ah,2
	mov	dl,'.'
	int	21h
	mov	eax,300		; delay for 300 ms
	call	Delay
	;-------------------------
	INVOKE ClearKeyboard,ESC_key	; check for Esc key
	jnz	L1					; continue loop if ZF=0

quit:
	call Clrscr
	exit
main ENDP

;---------------------------------------------------
ClearKeyboard PROC,
	scanCode:BYTE
;
; Clears the keyboard, while checking for a
; particular scan code.
; Receives: keyboard scan code
; Returns: Zero flag set if the ASCII code is
; found; otherwise, Zero flag is clear.
;---------------------------------------------------
	push	ax
L1:
	mov	ah,11h	; check keyboard buffer
	int	16h		; any key pressed?
	jz	noKey	; no: exit now (ZF=0)
	mov	ah,10h	; yes: remove from buffer
	int	16h
	cmp	ah,scanCode	; was it the exit key?
	je	quit			; yes: exit now (ZF=1)
	jmp	L1			; no: check buffer again

noKey:				; no key pressed
	or	al,1			; clear zero flag
quit:
	pop	ax
	ret
ClearKeyboard ENDP

END main