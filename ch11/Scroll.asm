; Scrolling the Console Window                (Scroll.asm)

; This program writes 50 lines of text to the console buffer,
; resizes, and scrolls the console window back to line 0.
; Demonstrates the SetConsoleWindowInfo function.

INCLUDE Irvine32.inc

.data
message BYTE ":  This line of text was written "
        BYTE "to the screen buffer",0dh,0ah
messageSize DWORD ($-message)

outHandle     HANDLE 0     			; standard output handle
bytesWritten  DWORD ?				; number of bytes written
lineNum DWORD 0
windowRect    SMALL_RECT <0,0,60,11>	; left,top,right,bottom

.code
main PROC
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outHandle,eax

.REPEAT
  	mov	eax,lineNum
  	call	WriteDec			; display each line number
	INVOKE WriteConsole,
	  outHandle,			; console output handle
	  ADDR message,       	; string pointer
	  messageSize,			; string length
	  ADDR bytesWritten,	; returns num bytes written
	  0					; not used
  	inc  lineNum			; next line number
.UNTIL lineNum > 50

; Resize and reposition the console window relative to the
; screen buffer.
	INVOKE SetConsoleWindowInfo,
	  outHandle,
	  TRUE,
	  ADDR windowRect

	call	Readchar		; wait for a key
	call	Clrscr		; clear the screen buffer
	call	Readchar		; wait for a second key

	INVOKE ExitProcess,0
main ENDP
END main