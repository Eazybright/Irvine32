TITLE DrawLine Program              (DrawLine.asm)

; This program draws text and a straight line in graphics mode.
; Last update: 4/3/2007
; Windows XP users: To run this program, open a command prompt using the 
; command_prompt shortcut provided in this folder. Then switch to full-screen 
; mode by pressing Alt-Enter, type Drawline and press Enter.

INCLUDE Irvine16.inc

;------------ Video Mode Constants -------------------
Mode_06 = 6		; 640 X 200,  2 colors
Mode_0D = 0Dh		; 320 X 200, 16 colors
Mode_0E = 0Eh		; 640 X 200, 16 colors
Mode_0F = 0Fh		; 640 X 350,  2 colors
Mode_10 = 10h		; 640 X 350, 16 colors
Mode_11 = 11h		; 640 X 480,  2 colors
Mode_12 = 12h		; 640 X 480, 16 colors
Mode_13 = 13h		; 320 X 200, 256 colors
Mode_6A = 6Ah		; 800 X 600, 16 colors

.data
saveMode  BYTE  ?		; save the current video mode
currentX  WORD 100		; column number (X-coordinate)
currentY  WORD 100		; row number (Y-coordinate)
COLOR = 1001b			; line color (cyan)

progTitle BYTE "DrawLine.asm"
TITLE_ROW = 5
TITLE_COLUMN = 14

; When using a 2-color mode, set COLOR to 1 (white)

.code
main PROC
	mov	ax,@data
	mov	ds,ax

; Save the current video mode.
	mov	ah,0Fh
	int	10h
	mov	saveMode,al

; Switch to a graphics mode.
	mov	ah,0   			; set video mode
	mov	al,Mode_6A
	int	10h

; Write the program name, as text.
	mov	ax,SEG progTitle
	mov	es,ax
	mov	bp,OFFSET progTitle

	mov	ah,13h			; function: write string
	mov	al,0				; mode: only character codes
	mov	bh,0				; video page 0
	mov	bl,7				; attribute = normal
	mov	cx,SIZEOF progTitle	; string length
	mov	dh,TITLE_ROW		; row (in character cells)
	mov	dl,TITLE_COLUMN	; column (in character cells)
	int	10h

; Draw a straight line.
	LineLength = 100

	mov	dx,currentY
	mov	cx,LineLength		; loop counter

L1:
	push	cx
	mov	ah,0Ch  			; write pixel
	mov	al,COLOR    		; pixel color
	mov	bh,0				; video page 0
	mov	cx,currentX
	int	10h
	inc	currentX
	;inc	color			; enable to see a multi-color line
	pop	cx
	Loop	L1

; Wait for a keystroke.
	mov	ah,0
	int	16h

; Restore the starting video mode.
	mov	ah,0   			; set video mode
	mov	al,saveMode   		; saved video mode
	int	10h
	exit
main ENDP

END main
