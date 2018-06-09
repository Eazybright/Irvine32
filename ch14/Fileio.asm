; Extended Open/Create            (Fileio.asm)

; Demonstration of 16-bit File I/O.
; The complete program does not appear in the text, but
; excerpts appear.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
Date WORD ?
handle WORD ?
actionTaken WORD ?
FileName BYTE "long_filename.txt",0
NewFile  BYTE "newfile.txt",0
cannotCreate BYTE "Cannot create newfile.txt",0dh,0ah,0
cannotOpen   BYTE "Cannot open long_filename.txt",0dh,0ah,0
failedMsg    BYTE "Cannot create or open newfile.txt",0dh,0ah,0

.code
main PROC
	mov  ax,@data
	mov  ds,ax

;Create new file, fail if it already exists:
	mov  ax,716Ch             	; Extended Open/Create
	mov  bx,2						; read-write
	mov  cx,0      				; normal attribute
	mov  dx,10h						; action: create
	mov  si,OFFSET NewFile
	int  21h
	jc   failed_create
	mov  handle,ax        		; file handle
	mov  actionTaken,cx   		; action taken to open file
	jmp  open_existing

failed_create:
	mov  dx,OFFSET cannotCreate
	call WriteString

open_existing:
	mov  ax,716Ch           ; Extended Open/Create
	mov  bx,0					; read-only
	mov  cx,0      			; normal attribute
	mov  dx,1					; open existing file
	mov  si,OFFSET Filename
	int  21h
	jc   failed_open
	mov  handle,ax        		; file handle
	mov  actionTaken,cx   		; action taken to open file
	jmp  create_or_truncate

failed_open:
	mov  dx,OFFSET cannotOpen
	call WriteString

create_or_truncate:
	mov  ax,716Ch           ; Extended Open/Create
	mov  bx,2					; read-write
	mov  cx,0      			; normal attribute
	mov  dx,10h + 02h			; action: create + truncate
	mov  si,OFFSET NewFile
	int  21h
	jc   failed
	mov  handle,ax        		; file handle
	mov  actionTaken,cx   		; action taken to open file
	jmp  finished

failed:
	mov  dx,OFFSET failedMsg
	call WriteString
	
finished:	
	exit
main ENDP
END main