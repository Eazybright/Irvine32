TITLE Color Text Window             (TextWin.asm)

; Displays a color window and writes text inside.
; Last update: 06/01/2006

INCLUDE Irvine16.inc
.data
message BYTE "Message in Window",0

.code
main PROC
	mov	ax,@data
	mov	ds,ax

; Scroll a window.
	mov	ax,0600h		; scroll window
	mov	bh,(blue SHL 4) OR yellow		; attribute
	mov	cx,050Ah		; upper-left corner
	mov	dx,0A30h		; lower-right corner
	int	10h

; Position the cursor inside the window.
	mov	ah,2			; set cursor position
	mov	dx,0714h		; row 7, col 20
	mov	bh,0			; video page 0
	int	10h

; Write some text in the window.
	mov	dx,OFFSET message
	call	WriteString

; Wait for a keypress.
	mov	ah,10h
	int	16h
	exit
main ENDP
END main