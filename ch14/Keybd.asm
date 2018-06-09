; Buffered Keyboard Input         (Keybd.asm)

; Test function 3Fh, read from file or device
; with the keyboard. Flush the buffer.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
firstName BYTE 15 DUP(?),0
lastName  BYTE 30 DUP(?),0

.code
main PROC
   mov  ax,@data
   mov  ds,ax

; Input the first name:
	mov  ah,3Fh
	mov  bx,0					; keyboard handle
	mov  cx,LENGTHOF firstName
	mov  dx,OFFSET firstName
	int  21h

; Disable the following line to see what happens
; when the buffer is not flushed:
	;call FlushBuffer

; Input the last name:
	mov  ah,3Fh
	mov  bx,0					; keyboard handle
	mov  cx,LENGTHOF lastName
	mov  dx,OFFSET lastName
	int  21h

; Display both names:
	mov  dx,OFFSET firstName
	call WriteString
	mov  dx,OFFSET lastName
	call WriteString

quit:
	call Crlf
    exit
main ENDP

;------------------------------------------
FlushBuffer PROC
;
; Flush the standard input buffer.
; Receives: nothing. Returns: nothing
;-----------------------------------------
.data
oneByte BYTE ?
.code
	pusha
L1:
    mov ah,3Fh				; read file/device
	mov bx,0				; keyboard handle
    mov cx,1				; one byte
    mov dx,OFFSET oneByte	; save it here
    int 21h				; call MS-DOS
    cmp oneByte,0Ah			; end of line yet?
    jne L1				; no: read another

	popa
	ret
FlushBuffer ENDP


END main