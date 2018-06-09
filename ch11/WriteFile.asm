; Using WriteFile                  (WriteFile.asm)

; This program writes text to an output file.

INCLUDE Irvine32.inc

.data
buffer BYTE "This text is written to an output file.",0dh,0ah
bufSize DWORD ($-buffer)
errMsg BYTE "Cannot create file",0dh,0ah,0
filename     BYTE "output.txt",0
fileHandle   DWORD ?	; handle to output file
bytesWritten DWORD ?    	; number of bytes written

.code
main PROC
	INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle,eax			; save file handle
	.IF eax == INVALID_HANDLE_VALUE
	  mov  edx,OFFSET errMsg		; Display error message
	  call WriteString
	  jmp  QuitNow
	.ENDIF

	INVOKE WriteFile,		; write text to file
	    fileHandle,		; file handle
	    ADDR buffer,		; buffer pointer
	    bufSize,			; number of bytes to write
	    ADDR bytesWritten,	; number of bytes written
	    0				; overlapped execution flag

	INVOKE CloseHandle, fileHandle

QuitNow:
	exit
main ENDP
END main