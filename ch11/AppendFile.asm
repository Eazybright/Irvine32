; Appending to a File                   (AppendFile.asm)

; This program appends text to an existing file.

INCLUDE Irvine32.inc

.data
buffer BYTE "This text is appended to an output file.",0dh,0ah
bufSize DWORD ($-buffer)
errMsg BYTE "Cannot open file",0dh,0ah,0
filename     BYTE "output.txt",0
fileHandle   HANDLE ?			; handle to output file
bytesWritten DWORD ?    			; number of bytes written

.code
main PROC
	INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle,eax			; save file handle
	.IF eax == INVALID_HANDLE_VALUE
	  mov  edx,OFFSET errMsg		; Display error message
	  call WriteString
	  jmp  QuitNow
	.ENDIF

	; Move the file pointer to the end of the file
	INVOKE SetFilePointer,
	  fileHandle,0,0,FILE_END

	; Append text to the file
	INVOKE WriteFile,
	    fileHandle, ADDR buffer, bufSize,
	    ADDR bytesWritten, 0

	INVOKE CloseHandle, fileHandle

QuitNow:
	exit
main ENDP
END main