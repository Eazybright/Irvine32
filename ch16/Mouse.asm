TITLE Tracking the Mouse                      (mouse.asm)

; Demonstrates basic mouse functions available via INT 33h.
; In Standard DOS mode, each character position in the DOS
; window equals 8 mouse units.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

GET_MOUSE_STATUS = 0
SHOW_MOUSE_POINTER = 1
HIDE_MOUSE_POINTER = 2
GET_CURSOR_SIZE = 3
GET_BUTTON_PRESS_INFO = 5
GET_MOUSE_POSITION_AND_STATUS = 3
ESCkey = 1Bh

.data
greeting    BYTE "[Mouse.exe] Press Esc to quit",0
statusLine  BYTE "Left button:                              "
	       BYTE "Mouse position: ",0
blanks      BYTE "                ",0
xCoord WORD 0		; current X-position
yCoord WORD 0		; current Y-position
xPress      WORD 0	; X-pos of last button press
yPress      WORD 0	; Y-pos of last button press

; Display coordinates.
statusRow	     BYTE ?
statusCol      BYTE 15
buttonPressCol BYTE 20
statusCol2     BYTE 60
coordCol       BYTE 65

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	call	Clrscr

; Get the screen X/Y coordinates.	
	call	GetMaxXY			; DH = rows, DL = columns
	dec	dh				; calculate status row value
	mov	statusRow,dh
	
; Hide the text cursor and display the mouse.
	call	HideCursor
	mov	dx,OFFSET greeting
	call	WriteString
	call	ShowMousePointer

; Display status information on the bottom screen line.
	mov	dh,statusRow
	mov	dl,0
	call	Gotoxy
	mov	dx,OFFSET statusLine
	call	Writestring

; Loop: show mouse coordinates, check for left mouse
; button press or keypress (Esc key).

L1:	call	ShowMousePosition
	call	LeftButtonPress	; check for button press
	mov	ah,11h			; key pressed already?
	int	16h
	jz	L2          		; no, continue the loop
	mov	ah,10h			; remove key from buffer
	int	16h
	cmp	al,ESCkey   		; yes. Is it the ESC key?
	je	quit        		; yes, quit the program
L2:	jmp	L1 				; no, continue the loop

; Hide the mouse, restore the text cursor, clear
; the screen, and wait for a key press.
quit:
	call	HideMousePointer
	call	ShowCursor
	call	Clrscr
	call	WaitMsg
	exit
main ENDP

;---------------------------------------------------------
GetMousePosition PROC USES ax
;
; Gets the current mouse position and button status.
; Receives: nothing
; Returns:  BX = button status (0 = left button down,
;           (1 = right button down, 2 = center button down)
;           CX = X-coordinate
;           DX = Y-coordinate
;---------------------------------------------------------
	mov	ax,GET_MOUSE_POSITION_AND_STATUS
	int	33h
	ret
GetMousePosition ENDP

;---------------------------------------------------------
HideCursor PROC USES ax cx
;
; Hide the text cursor by setting its top line
; value to an illegal value.
; Receives: nothing. Returns: nothing
;---------------------------------------------------------
	mov	ah,GET_CURSOR_SIZE
	int	10h
	or	ch,30h		; set upper row to illegal val
	mov	ah,1			; set cursor size
	int	10h
	ret
HideCursor ENDP

;---------------------------------------------------------
ShowCursor PROC USES ax cx
;
; Show the text cursor by setting size to default.
; Receives: nothing. Returns: nothing
;---------------------------------------------------------
	mov	ah,GET_CURSOR_SIZE
	int	10h
	mov	ah,1			; set cursor size
	mov	cx,0607h		; default size
	int	10h
	ret
ShowCursor ENDP

;---------------------------------------------------------
HideMousePointer PROC USES ax
;
; Hides the mouse pointer. 
; Receives: nothing. Returns: nothing
;---------------------------------------------------------
	mov	ax,HIDE_MOUSE_POINTER
	int	33h
	ret
HideMousePointer ENDP

;---------------------------------------------------------
ShowMousePointer PROC USES ax
;
; Makes the mouse pointer visible.
; Receives: nothing. Returns: nothing
;---------------------------------------------------------
	mov	ax,SHOW_MOUSE_POINTER
	int	33h
	ret
ShowMousePointer ENDP

;---------------------------------------------------------
LeftButtonPress PROC
;
; Checks for the most recent left mouse button press
; and displays the mouse location.
; Receives: nothing. Returns: nothing
;---------------------------------------------------------
	pusha
	mov	ax,GET_BUTTON_PRESS_INFO
	mov	al,5			; (button press information)
	mov	bx,0			; specify the left button
	int	33h

; Exit proc if the coordinates have not changed.
	cmp	cx,xPress		; same X coordinate?
	jne	L1			; no: continue
	cmp	dx,yPress		; same Y coordinate?
	je	L2			; yes: exit

; Coordinates have changed, so save them.
L1:	mov	xPress,cx
	mov	yPress,dx

; Position the cursor, clear the old numbers.
	mov	dh,statusRow	; screen row
	mov	dl,statusCol	; screen column
	call	Gotoxy
	push	dx
	mov	dx,OFFSET blanks
	call	WriteString
	pop	dx

; Show coordinates where mouse button was pressed.
	call	Gotoxy
	mov	ax,xCoord
	call	WriteDec
	mov	dl,buttonPressCol
	call	Gotoxy
	mov	ax,yCoord
	call	WriteDec

L2:	popa
	ret
LeftButtonPress ENDP

;---------------------------------------------------------
SetMousePosition PROC
;
; Set the mouse's position on the screen.
; Receives: CX = X-coordinate
;           DX = Y-coordinate
; Returns:  nothing
;---------------------------------------------------------
	mov	ax,4
	int	33h
	ret
SetMousePosition ENDP

;---------------------------------------------------------
ShowMousePosition PROC
;
; Get and show the mouse coordinates at the
; bottom of the screen.
; Receives: nothing
; Returns:  nothing
;---------------------------------------------------------
	pusha
	call	GetMousePosition

; Exit proc if the coordinates have not changed.
	cmp	cx,xCoord			; same X coordinate?
	jne	L1				; no: continue
	cmp	dx,yCoord			; same Y coordinate?
	je	L2				; yes: exit

; Save the new X and Y coordinates.
L1:	mov	xCoord,cx	
	mov	yCoord,dx

; Position the cursor, clear the old numbers.
	mov	dh,statusRow		; screen row
	mov	dl,statusCol2		; screen column
	call	Gotoxy
	push	dx
	mov	dx,OFFSET blanks
	call	WriteString
	pop	dx

; Show the mouse coordinates.
	call	Gotoxy
	mov	ax,xCoord
	call	WriteDec
	mov	dl,coordCol		; screen column
	call	Gotoxy
	mov	ax,yCoord
	call	WriteDec

L2:	popa
	ret
ShowMousePosition ENDP
END main