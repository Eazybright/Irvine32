; Finite State Machine              (Finite.asm)

; This program implements a finite state machine that
; accepts an integer with an optional leading sign.

INCLUDE Irvine32.inc

ENTER_KEY = 13
.data
InvalidInputMsg BYTE "Invalid input",13,10,0

.code
main PROC
	call Clrscr

StateA:
	call	Getnext       		; read next char into AL
	cmp	al,'+'         	; leading + sign?
	je	StateB          	; go to State B
	cmp	al,'-'         	; leading - sign?
	je	StateB          	; go to State B
	call	IsDigit       		; ZF = 1 if AL contains a digit
	jz	StateC			; go to State C
	call	DisplayErrorMsg  	; invalid input found
	jmp	Quit

StateB:
	call	Getnext       		; read next char into AL
	call	IsDigit       		; ZF = 1 if AL contains a digit
	jz	StateC
	call	DisplayErrorMsg  	; invalid input found
	jmp	Quit

StateC:
	call	Getnext       		; read next char into AL
	call	IsDigit       		; ZF = 1 if AL contains a digit
	jz	StateC
	cmp	al,ENTER_KEY		; Enter key pressed?
	je	Quit				; yes: quit
	call	DisplayErrorMsg  	; no: invalid input found
	jmp	Quit

Quit:
	call	Crlf
	exit
main ENDP

;-----------------------------------------------
Getnext PROC
;
; Reads a character from standard input.
; Receives: nothing
; Returns: AL contains the character
;-----------------------------------------------
	 call ReadChar			; input from keyboard
	 call WriteChar		; echo on screen
	 ret
Getnext ENDP

;-----------------------------------------------
DisplayErrorMsg PROC
;
; Displays an error message indicating that
; the input stream contains illegal input.
; Receives: nothing. 
; Returns: nothing
;-----------------------------------------------
	 push  edx
	 mov	  edx,OFFSET InvalidInputMsg
	 call  WriteString
	 pop	  edx
	 ret
DisplayErrorMsg ENDP
END main