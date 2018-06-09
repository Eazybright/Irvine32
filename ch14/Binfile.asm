; Binary File Program         (Binfile.asm)

; This program creates a binary file containing 
; an array of doublewords.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
myArray DWORD 50 DUP(?)

fileName   BYTE "binary array file.bin",0
fileHandle WORD ?
commaStr   BYTE ", ",0

; Set CreateFile to zero if you just want to
; read and display the existing binary file.
CreateFile = 1

.code
main PROC
	mov	ax,@data
	mov	ds,ax
                                                             
.IF CreateFile EQ 1
	call	FillTheArray
	call	DisplayTheArray
	call	CreateTheFile
	call	WaitMsg
	call	Crlf
.ENDIF
	call	ReadTheFile
	call	DisplayTheArray

quit:
	call	Crlf
    exit
main ENDP

;------------------------------------------------------
ReadTheFile PROC
;
; Open and read the binary file.
; Receives: nothing.  
; Returns: nothing
;------------------------------------------------------
	mov	ax,716Ch    		; extended file open
	mov	bx,0				; mode: read-only
	mov	cx,0      		; attribute: normal
	mov	dx,1				; open existing file
	mov	si,OFFSET fileName	; filename
	int	21h       		; call MS-DOS
	jc	quit				; quit if error
	mov	fileHandle,ax		; save handle

; Read the input file, then close the file.
	mov	ah,3Fh			; read file or device
	mov	bx,fileHandle		; file handle
	mov	cx,SIZEOF myArray	; max bytes to read
	mov	dx,OFFSET myArray	; buffer pointer
	int	21h
	jc	quit				; quit if error
	mov	ah,3Eh    		; function: close file
	mov	bx,fileHandle		; output file handle
	int	21h       		; call MS-DOS

quit:
	ret
ReadTheFile ENDP

;------------------------------------------------------
DisplayTheArray PROC
;
; Display the doubleword array.
; Receives: nothing.  
; Returns: nothing
;------------------------------------------------------
	mov	CX,LENGTHOF myArray
	mov	si,0
L1:
	mov	eax,myArray[si]		; get a number
	call	WriteHex				; display the number
	mov	edx,OFFSET commaStr		; display a comma
	call	WriteString
	add	si,TYPE myArray		; next array position
	loop	L1
	ret
DisplayTheArray ENDP

;------------------------------------------------------
FillTheArray PROC
;
; Fill the array with random integers.
; Receives: nothing.  
; Returns: nothing
;------------------------------------------------------
	mov	CX,LENGTHOF myArray
	mov	si,0
L1:
	mov	eax,1000			; generate random integers
	call	RandomRange		; between 0 - 999 in EAX
	mov	myArray[si],eax	; store in the array
	add	si,TYPE myArray	; next array position
	loop	L1
	ret
FillTheArray ENDP

;------------------------------------------------------
CreateTheFile PROC
;
; Create a file containing binary data.
; Receives: nothing.  
; Returns: nothing
;------------------------------------------------------
	mov	ax,716Ch    		; create file
	mov	bx,1				; mode: write only
	mov	cx,0      		; normal file
	mov	dx,12h			; action: create/truncate
	mov	si,OFFSET fileName	; filename
	int	21h       		; call MS-DOS
	jc	quit				; quit if error
	mov	fileHandle,ax		; save handle

; Write the integer array to the file.
	mov	ah,40h			; write file or device
	mov	bx,fileHandle		; output file handle
	mov	cx,SIZEOF myArray	; number of bytes
	mov	dx,OFFSET myArray	; buffer pointer
	int	21h
	jc	quit				; quit if error

; Close the file.
	mov  ah,3Eh    		; function: close file
	mov  bx,fileHandle		; output file handle
	int  21h       		; call MS-DOS

quit:
	ret
CreateTheFile ENDP
END main