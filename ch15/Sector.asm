TITLE Sector Display Program              (Sector.asm)

; Demonstrates INT 21h function 7305h (ABSDiskReadWrite)
; This Real-mode program reads and displays disk sectors.
; Works on FAT16 & FAT32 file systems running under Windows
; 95, 98, and Millenium.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

Setcursor PROTO, row:BYTE, col:BYTE
EOLN EQU <0dh,0ah>
ESC_KEY = 1Bh
DATA_ROW = 5
DATA_COL = 0
SECTOR_SIZE = 512
READ_MODE = 0		; for Function 7505h

DiskIO STRUCT
	startSector DWORD ?		; starting sector number
	numSectors  WORD 1		; number of sectors
	bufferOfs   WORD OFFSET buffer	; buffer offset
	bufferSeg   WORD SEG buffer		; buffer segment
DiskIO ENDS

.data
driveNumber BYTE ?
diskStruct DiskIO <>
buffer BYTE SECTOR_SIZE DUP(0),0		    ; one sector

curr_row   BYTE  ?
curr_col   BYTE  ?

; String resources
strLine       BYTE  EOLN,79 DUP(0C4h),EOLN,0
strHeading    BYTE "Sector Display Program (Sector.exe)"
              BYTE EOLN,EOLN,0
strAskSector  BYTE "Enter starting sector number: ",0
strAskDrive   BYTE "Enter drive number (1=A, 2=B, "
	          BYTE "3=C, 4=D, 5=E, 6=F): ",0
strCannotRead BYTE EOLN,"*** Cannot read the sector. "
	          BYTE "Press any key...", EOLN, 0
strReadingSector \
	BYTE "Press Esc to quit, or any key to continue..."
	BYTE EOLN,EOLN,"Reading sector: ",0

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	call	Clrscr
	mov	dx,OFFSET strHeading 	; display greeting
	call	Writestring			; ask user for...
	call	AskForSectorNumber

L1:	call	Clrscr
	call	ReadSector			; read a sector
	jc	L2                 		; quit if error
	call	DisplaySector
	call	ReadChar
	cmp	al,ESC_KEY         		; Esc pressed?
	je	L3                 		; yes: quit
	inc	diskStruct.startSector   ; next sector
	jmp	L1					; repeat the loop

L2:	mov	dx,OFFSET strCannotRead	; error message
	call	Writestring
	call	ReadChar

L3:	call	Clrscr
	exit
main ENDP

;-----------------------------------------------------
AskForSectorNumber PROC
;
; Prompts the user for the starting sector number
; and drive number. Initializes the startSector
; field of the DiskIO structure, as well as the
; driveNumber variable.
;-----------------------------------------------------
	pusha
	mov	dx,OFFSET strAskSector
	call	WriteString
	call	ReadInt
	mov	diskStruct.startSector,eax
	call	Crlf
	mov	dx,OFFSET strAskDrive
	call	WriteString
	call	ReadInt
	mov	driveNumber,al
	call	Crlf
	popa
	ret
AskForSectorNumber ENDP

;-----------------------------------------------------
ReadSector PROC
;
; Reads a sector into the input buffer.
; Receives: DL = Drive number
; Requires: DiskIO structure must be initialized.
; Returns:  If CF=0, the operation was successful;
;           otherwise, CF=1 and AX contains an
;           error code.
;-----------------------------------------------------
	pusha
	mov	ax,7305h			; ABSDiskReadWrite
	mov	cx,-1              	; always -1
	mov	dl,driveNumber		; drive number
	mov	bx,OFFSET diskStruct		; sector number
	mov	si,READ_MODE		; read mode
	int	21h               	; read disk sector
	popa
	ret
ReadSector ENDP

;-----------------------------------------------------
DisplaySector PROC
;
; Display the sector data in <buffer>, using INT 10h
; BIOS function calls. This avoids filtering of ASCII
; control codes.
; Receives: nothing. Returns: nothing.
; Requires: buffer must contain sector data.
;-----------------------------------------------------
	mov	dx,OFFSET strHeading	; display heading
	call	WriteString
	mov	eax,diskStruct.startSector	; display sector number
	call	WriteDec
	mov	dx,OFFSET strLine    	; horizontal line
	call	Writestring
	mov	si,OFFSET buffer    	; point to buffer
	mov	curr_row,DATA_ROW		; set row, column
	mov	curr_col,DATA_COL
	INVOKE SetCursor,curr_row,curr_col

	mov	cx,SECTOR_SIZE    		; loop counter
	mov	bh,0              		; video page 0
L1:	push	cx                		; save loop counter
	mov	ah,0Ah            		; display character
	mov	al,[si]           		; get byte from buffer
	mov	cx,1              		; display it
	int	10h
	call	MoveCursor
	inc	si                		; point to next byte
	pop	cx                		; restore loop counter
	loop	L1                		; repeat the loop
	ret
DisplaySector ENDP

;-----------------------------------------------
MoveCursor PROC
;
; Advance the cursor to the next column,
; check for possible wraparound on screen.
;-----------------------------------------------
	cmp	curr_col,79		; last column?
	jae	L1         		; yes: go to next row
	inc	curr_col			; no: increment column
	jmp	L2
L1:	mov	curr_col,0		; next row
	inc	curr_row
L2:	INVOKE Setcursor,curr_row,curr_col
	ret
MoveCursor ENDP

;-----------------------------------------------------
Setcursor PROC USES dx,
	row:BYTE, col:BYTE
;
; Set the screen cursor position
;-----------------------------------------------------
	mov	dh, row
	mov	dl, col
	call	Gotoxy
	ret
Setcursor ENDP
END main