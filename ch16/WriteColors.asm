TITLE Writing Text Colors              (WriteColors.asm)

; Demonstration of WriteConsoleOutputCharacter,
; and WriteConsoleOutputAttribute functions.
; Last update: 08/22/2006

INCLUDE Irvine32.inc
.data
outHandle    DWORD ?
cellsWritten DWORD ?
xyPos COORD <10,2>

; Array of character codes:
buffer BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	   BYTE 16,17,18,19,20
BufSize DWORD ($ - buffer)

; Array of attributes:
attributes WORD 0Fh,0Eh,0Dh,0Ch,0Bh,0Ah,9,8,7,6
           WORD 5,4,3,2,1,0F0h,0E0h,0D0h,0C0h,0B0h

.code
main PROC

; Get the Console standard output handle:
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	mov outHandle,eax

; Set the colors from (10,2) to (30,2):
INVOKE WriteConsoleOutputAttribute,
	  outHandle, ADDR attributes,
	  BufSize, xyPos,
	  ADDR cellsWritten

; Write character codes 1 to 20:
	INVOKE WriteConsoleOutputCharacter,
	  outHandle, ADDR buffer, BufSize,
	  xyPos, ADDR cellsWritten

	call ReadChar
	exit
main ENDP
END main