TITLE Control-Break Handler             (Ctrlbrk.asm)

; This program installs its own Ctrl-Break handler and
; prevents the user from using Ctrl-Break (or Ctrl-C)
; to halt the program. The program inputs and echoes
; keystrokes until the Esc key is pressed.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
breakMsg BYTE "BREAK",0
msg	BYTE "Ctrl-Break demonstration."
	BYTE  0dh,0ah
	BYTE "This program disables Ctrl-Break (Ctrl-C). Press any"
	BYTE  0dh,0ah
	BYTE "keys to continue, or press ESC to end the program."
	BYTE  0dh,0ah,0

.code
main PROC
	mov   ax,@data
	mov   ds,ax

	mov   dx,OFFSET msg	; display greeting message
	call  Writestring

install_handler:
	push  ds          	; save DS
	mov   ax,@code    	; initialize DS
	mov   ds,ax
	mov   ah,25h      	; set interrupt vector
	mov   al,23h      	; for interrupt 23h
	mov   dx,OFFSET break_handler
	int   21h
	pop   ds          	; restore DS

L1:	mov   ah,1        	; wait for a key, echo it
	int   21h
	cmp   al,1Bh      	; ESC pressed?
	jnz   L1          	; no: continue

	exit
main ENDP

; The following procedure executes when
; Ctrl-Break (Ctrl-C) is pressed.

break_handler PROC
	push  ax
	push  dx
	mov   dx,OFFSET breakMsg
	call  Writestring
	pop   dx
	pop   ax
	iret
break_handler ENDP
END main