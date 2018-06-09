TITLE Cartesian Coordinates                 (Pixel2.asm)

; This program switches into 800 X 600 graphics mode and
; draws the X and Y axes of a Cartesian coordinate system.
; Switch to full-screen mode before running this program.
; Color constants are defined in Irvine16.inc.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

Mode_6A = 6Ah		; 800 X 600, 16 colors
X_axisY = 300
X_axisX = 50
X_axisLen = 700

Y_axisX = 400
Y_axisY = 30
Y_axisLen = 540

.data
saveMode BYTE ?

.code
main PROC
	mov ax,@data
	mov ds,ax

; Save the current video mode
	mov  ah,0Fh		; get video mode
	int  10h
	mov  saveMode,al

; Switch to a graphics mode
	mov  ah,0   		; set video mode
	mov  al,Mode_6A	; 800 X 600, 16 colors
	int  10h

; Draw the X-axis
	mov  cx,X_axisX	; X-coord of start of line
	mov  dx,X_axisY	; Y-coord of start of line
	mov  ax,X_axisLen 	; length of line
	mov  bl,white		; line color (see IRVINE16.inc)
	call DrawHorizLine	; draw the line now

; Draw the Y-axis
	mov  cx,Y_axisX	; X-coord of start of line
	mov  dx,Y_axisY	; Y-coord of start of line
	mov  ax,Y_axisLen	; length of line
	mov  bl,white		; line color
	call DrawVerticalLine	; draw the line now

; Wait for a keystroke
	mov  ah,10h		; wait for key
	int  16h

; Restore the starting video mode
	mov  ah,0   		; set video mode
	mov  al,saveMode   	; saved video mode
	int  10h

	exit
main endp

;------------------------------------------------------
DrawHorizLine PROC
;
; Draws a horizontal line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, and BL = color
; Returns: nothing
;------------------------------------------------------
.data
currX WORD ?

.code
	pusha
	mov  currX,cx	; save X-coordinate
	mov  cx,ax	; loop counter

DHL1:
	push cx		; save loop counter
	mov  al,bl	; color
	mov  ah,0Ch	; draw pixel
	mov  bh,0		; video page
	mov  cx,currX	; retrieve X-coordinate
	int  10h
	inc  currX	; move 1 pixel to the right
	pop  cx		; restore loop counter
	Loop DHL1

	popa
	ret
DrawHorizLine ENDP

;------------------------------------------------------
DrawVerticalLine PROC
;
; Draws a vertical line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, BL = color
; Returns: nothing
;------------------------------------------------------
.data
currY WORD ?

.code
	pusha
	mov  currY,dx	; save Y-coordinate
	mov  currX,cx	; save X-coordinate
	mov  cx,ax	; loop counter

DVL1:
	push cx		; save loop counter
	mov  al,bl	; color
	mov  ah,0Ch	; function: draw pixel
	mov  bh,0		; set video page
	mov  cx,currX	; set X-coordinate
	mov  dx,currY	; set Y-coordinate
	int  10h		; draw the pixel
	inc  currY	; move down 1 pixel
	pop  cx		; restore loop counter
	Loop DVL1

	popa
	ret
DrawVerticalLine ENDP
END main