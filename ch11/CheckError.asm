; Check for Errors             (CheckError.asm)

; Demonstrates the WriteWindowsMsg function when
; handling a Windows API error.

INCLUDE Irvine32.inc

.data
filename    BYTE "nonexistentfile.txt",0
fileHandle  DWORD ?

.code
main PROC

; Attempt to open a file.
	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax

; Check for errors.
	.IF eax == INVALID_HANDLE_VALUE
	call	WriteWindowsMsg
	jmp	quit
	.ENDIF

; Close the file handle.
	mov	eax,fileHandle
	call	CloseFile

quit:
	exit
main ENDP

END main