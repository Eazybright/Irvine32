TITLE Color String Example              (ColorStr.asm)

; This program writes a multicolor string on the display.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
ATTRIB_HI = 10000000b
string BYTE "ABCDEFGHIJKLMOP"
color  BYTE 1

.code
main PROC
	mov  ax,@data
	mov  ds,ax

	call ClrScr
	call EnableBlinking
	mov  cx,SIZEOF string
	mov  si,OFFSET string

L1:	push cx			; save loop counter
	mov  ah,9      	; write character/attribute
	mov  al,[si]   	; character to display
	mov  bh,0      	; video page 0
	mov  bl,color		; attribute
	or   bl,ATTRIB_HI	; set blink/intensity bit
	mov  cx,1     		; display it one time
	int  10h
	mov  cx,1			; advance cursor to
	call AdvanceCursor	; next screen column
	inc  color		; next color
	inc  si			; next character
	pop  cx			; restore loop counter
	Loop L1

	call Crlf
	exit
main ENDP

;--------------------------------------------------
EnableBlinking PROC
;
; Enable blinking (using the high bit of color
; attributes). In MS-Windows, this only works if
; the program is running in full-screen mode.
; Receives: nothing.
; Returns: nothing
;--------------------------------------------------
	push ax
	push bx
	mov ax,1003h
	mov bl,1			; blinking is enabled
	int 10h
	pop bx
	pop ax
	ret
EnableBlinking ENDP

;--------------------------------------------------
AdvanceCursor PROC
;
; Advances the cursor n columns to the right.
; Receives: CX = number of columns
; Returns: nothing
;--------------------------------------------------
	pusha
L1:
	push cx			; save loop counter
	mov  ah,3      	; get cursor position
	mov  bh,0			; into DH, DL
	int  10h			; changes CX register!
	inc  dl        	; increment column
	mov  ah,2      	; set cursor position
	int  10h
	pop  cx			; restore loop counter
	loop L1			; next column

	popa
	ret
AdvanceCursor ENDP
END main
