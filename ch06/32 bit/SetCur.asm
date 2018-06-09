;  Set Cursor Example         (SetCur.asm)

; Use the .IF and .ENDIF directives to perform
; run-time range checks on parameters passed to
; the SetCursorPosition procedure.

INCLUDE Irvine32.inc

.code
main PROC

	mov dl,79			; X-coordinate
	mov dh,24			; Y-coordinate
	call SetCursorPosition

	exit
main ENDP


SetCursorPosition PROC
; Set the cursor position.
; Receives: DL = X-coordinate, DH = Y-coordinate
; Checks the ranges of DL and DH.
;------------------------------------------------
.data
BadXCoordMsg BYTE "X-Coordinate out of range!",0Dh,0Ah,0
BadYCoordMsg BYTE "Y-Coordinate out of range!",0Dh,0Ah,0
.code
	.IF (DL < 0) || (DL > 79)
	   mov  edx,OFFSET BadXCoordMsg
	   call WriteString
	   jmp  quit
	.ENDIF
	.IF (DH < 0) || (DH > 24)
	   mov  edx,OFFSET BadYCoordMsg
	   call WriteString
	   jmp  quit
	.ENDIF
	call Gotoxy

quit:
	ret
SetCursorPosition ENDP

END main