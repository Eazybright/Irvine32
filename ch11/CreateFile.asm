; Creating a File					(CreateFile.asm)

; Inputs text from the user, writes the text to an output file. 

INCLUDE Irvine32.inc  

BUFFER_SIZE = 501
.data
buffer BYTE BUFFER_SIZE DUP(?)
filename     BYTE "output.txt",0
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [output.txt]: ",0
str3 BYTE "Enter up to 500 characters and press "
     BYTE "[Enter]: ",0dh,0ah,0

.code
main PROC
; Create a new text file.
	mov	edx,OFFSET filename
	call	CreateOutputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax, INVALID_HANDLE_VALUE	; error found?
	jne	file_ok					; no: skip
	mov	edx,OFFSET str1			; display error
	call	WriteString
	jmp	quit
file_ok:

; Ask the user to input a string.
	mov	edx,OFFSET str3		; "Enter up to ...."
	call	WriteString
	mov	ecx,BUFFER_SIZE		; Input a string
	mov	edx,OFFSET buffer
	call	ReadString
	mov	stringLength,eax		; counts chars entered

; Write the buffer to the output file.
	mov	eax,fileHandle
	mov	edx,OFFSET buffer
	mov	ecx,stringLength
	call	WriteToFile
	mov	bytesWritten,eax		; save return value
	call	CloseFile
	
; Display the return value.
	mov	edx,OFFSET str2		; "Bytes written"
	call	WriteString
	mov	eax,bytesWritten
	call	WriteDec
	call	Crlf
	
quit:
	exit
main ENDP
END main