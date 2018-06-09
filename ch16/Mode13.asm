; Memory Mapped Graphics, Mode 13        	(Mode13.asm)

Comment !

This program demonstrates direct memory mapping in video
graphics Mode 13 (320 x 200, 256 colors). The video memory
is a two-dimensional array of memory bytes which can be addressed
and modified individually. Each byte represents a pixel on
the screen, and each byte contains an index into the color
palette.
Last update: 06/01/2006
!

INCLUDE Irvine16.inc

VIDEO_PALLETE_PORT = 3C8h
COLOR_SELECTION_PORT = 3C9h
COLOR_INDEX = 1
PALLETE_INDEX_BACKGROUND = 0
SET_VIDEO_MODE = 0
GET_VIDEO_MODE = 0Fh
VIDE0_SEGMENT = 0A000h
WAIT_FOR_KEYSTROKE = 10h
MODE_13 = 13h

.data
saveMode BYTE ?	; saved video mode
xVal WORD ?		; x-coordinate
yVal WORD ?		; y-coordinate
msg BYTE "Welcome to Mode 13!",0

.code
main PROC
	mov	ax,@data
	mov	ds,ax

	call	SetVideoMode
	call	SetScreenBackground
	
; Display a greeting message.

	mov	edx,OFFSET msg		; DOS calls work also
	call	WriteString
	
	call	Draw_Some_Pixels
	call	RestoreVideoMode
	exit
main ENDP

;------------------------------------------------
SetScreenBackground PROC
;
; Sets the screen's background color. Video  
; palette index 0 is the background color.
;------------------------------------------------
	mov	dx,VIDEO_PALLETE_PORT
	mov	al,PALLETE_INDEX_BACKGROUND
	out	dx,al

; Set the screen background color to dark blue.

	mov	dx,COLOR_SELECTION_PORT
	mov	al,0		; red
	out	dx,al
	mov	al,0		; green
	out	dx,al
	mov	al,35	; blue (intensity 35/63)
	out	dx,al

	ret
SetScreenBackground endp

;-----------------------------------------------
SetVideoMode PROC
;
; Saves the current video mode, switches to a
; new mode, and points ES to the video segment.
;-----------------------------------------------
	mov	ah,GET_VIDEO_MODE
	int	10h
	mov	saveMode,al	; save it

	mov	ah,SET_VIDEO_MODE
	mov	al,MODE_13	; to mode 13h
	int	10h

	push	VIDE0_SEGMENT	; video segment address
	pop	es             ; ES points to video segment

	ret
SetVideoMode ENDP

;---------------------------------------------
RestoreVideoMode PROC
;
; Waits for a key to be pressed and restores
; the video mode to its original value.
;----------------------------------------------
	mov	ah,WAIT_FOR_KEYSTROKE
	int	16h
	mov	ah,SET_VIDEO_MODE   ; reset video mode
	mov	al,saveMode   		; to saved mode
	int	10h
	ret
RestoreVideoMode ENDP

;-----------------------------------------------
Draw_Some_Pixels PROC
;
; Sets individual palette colors and draws 
; several pixels.
;------------------------------------------------

; Change the color at index 1 to white (63,63,63).
	
	mov	dx,VIDEO_PALLETE_PORT
	mov	al,1		; set palette index 1
	out	dx,al

	mov	dx,COLOR_SELECTION_PORT
	mov	al,63	; red
	out	dx,al
	mov	al,63	; green
	out	dx,al
	mov	al,63	; blue
	out	dx,al

; Calculate the video buffer offset of the first pixel.
; Method is specific to mode 13h, which is 320 X 200.
	
	mov	xVal,160	; middle of screen
	mov	yVal,100
	mov	ax,320	; 320 for video mode 13h
	mul	yVal		; y-coordinate
	add	ax,xVAl	; x-coordinate

	; Place the color index into the video buffer.
	
	mov	cx,10	; draw 10 pixels
	mov	di,ax	; AX contains buffer offset

; Draw the pixels now. By default, the assembler assumes 
; DI is an offset from the segment address in DS. The 
; segment override ES:[DI] tells the CPU to use the segment 
; address in ES instead. ES currently points to VRAM.
	
DP1:
	mov	BYTE PTR es:[di],COLOR_INDEX
	add	di,5		; move 5 pixels to the right
	loop	DP1

	ret
Draw_Some_Pixels ENDP

END main