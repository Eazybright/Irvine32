; Read a text file         (Readfile.asm)

; Read, display, and copy a text file.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
BufSize = 5000
infile    BYTE "my_text_file.txt",0
outfile   BYTE "my_output_file.txt",0
inHandle  WORD ?
outHandle WORD ?
buffer    BYTE BufSize DUP(?)
bytesRead WORD ?

.code
main PROC
	mov	ax,@data
	mov	ds,ax

; Open the input file
	mov	ax,716Ch   		; extended create or open
	mov	bx,0      		; mode = read-only
	mov	cx,0				; normal attribute
	mov	dx,1				; action: open
	mov	si,OFFSET infile
	int	21h       		; call MS-DOS
	jc	quit				; quit if error
	mov	inHandle,ax

; Read the input file
	mov	ah,3Fh			; read file or device
	mov	bx,inHandle		; file handle
	mov	cx,BufSize		; max bytes to read
	mov	dx,OFFSET buffer	; buffer pointer
	int	21h
	jc	quit				; quit if error
	mov	bytesRead,ax

; Display the buffer
	mov	ah,40h			; write file or device
	mov	bx,1				; console output handle
	mov	cx,bytesRead		; number of bytes
	mov	dx,OFFSET buffer	; buffer pointer
	int	21h
	jc	quit				; quit if error

; Close the file
	mov	ah,3Eh    		; function: close file
	mov	bx,inHandle		; input file handle
	int  21h       		; call MS-DOS
	jc	quit				; quit if error

; Create the output file
	mov	ax,716Ch   		; extended create or open
	mov	bx,1      		; mode = write-only
	mov	cx,0				; normal attribute
	mov	dx,12h			; action: create/truncate
	mov	si,OFFSET outfile
	int	21h       		; call MS-DOS
	jc	quit				; quit if error
	mov	outHandle,ax		; save handle

; Write buffer to new file
	mov	ah,40h			; write file or device
	mov	bx,outHandle		; output file handle
	mov	cx,bytesRead		; number of bytes
	mov	dx,OFFSET buffer	; buffer pointer
	int	21h
	jc	quit				; quit if error

; Close the file
	mov	ah,3Eh    		; function: close file
	mov	bx,outHandle		; output file handle
	int	21h       		; call MS-DOS

quit:
	call	Crlf
	exit
main ENDP
END main