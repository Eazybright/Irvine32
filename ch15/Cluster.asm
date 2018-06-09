TITLE  Cluster Display Program           (Cluster.asm)

; This program reads the directory of drive A, decodes
; the file allocation table, and displays the list of
; clusters allocated to each file.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

; Attributes specific to 1.44MB diskettes:
FATSectors = 9		; num sectors, first copy of FAT
DIRSectors = 14	; num sectors, root directory
DIR_START = 19		; starting directory sector num

SECTOR_SIZE = 512
DRIVE_A = 0
FAT_START = 1		; starting sector of FAT
EOLN equ <0dh,0ah>

Directory STRUCT
	fileName   BYTE 8 dup(?)
	extension  BYTE 3 dup(?)
	attribute  BYTE ?
	reserved   BYTE 10 dup(?)
	time       WORD ?
	date       WORD ?
	startingCluster WORD ?
	fileSize   DWORD ?
Directory ENDS
ENTRIES_PER_SECTOR = SECTOR_SIZE / (size Directory)

.data
heading LABEL byte
	BYTE  'Cluster Display Program           (CLUSTER.EXE)'
	BYTE   EOLN,EOLN,'The following clusters are allocated '
	BYTE  'to each file:',EOLN,EOLN,0

fattable WORD ((FATSectors * SECTOR_SIZE) / 2) DUP(?)
dirbuf Directory (DIRSectors * ENTRIES_PER_SECTOR) DUP(<>)
driveNumber BYTE ?

.code
main PROC
	call Initialize
	mov  ax,OFFSET dirbuf
	mov  ax,OFFSET driveNumber
	call LoadFATandDir
	jc   A3								; quit if we failed
	mov  si,OFFSET dirbuf					; index into the directory

A1:	cmp (Directory PTR [si]).filename,0		; entry never used?
	je  A3								; yes: must be the end
	cmp (Directory PTR [si]).filename,0E5h		; entry deleted?
	je  A2								; yes: skip to next entry
	cmp (Directory PTR [si]).filename,2Eh		; parent directory?
	je  A2								; yes: skip to next entry
	cmp (Directory PTR [si]).attribute,0Fh		; extended filename?
	je  A2
	test (Directory PTR [si]).attribute,18h		; vol or directory name?
	jnz A2                       				; yes: skip to next entry
	call displayClusters          			; must be a valid entry

A2:	add   si,32							; point to next entry
	jmp   A1
A3:	.exit
main ENDP

;----------------------------------------------------------
LoadFATandDir PROC
; Load FAT and root directory sectors.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------
	pusha
	; Load the FAT
	mov  al,DRIVE_A
	mov  cx,FATsectors
	mov  dx,FAT_START
	mov  bx,OFFSET fattable
	int  25h						; read sectors
	add  sp,2						; pop old flags off stack
	
	; Load the Directory
	mov  cx,DIRsectors
	mov  dx,DIR_START
	mov  bx,OFFSET dirbuf
	int  25h
	add  sp,2
	popa
	ret
LoadFATandDir ENDP

;----------------------------------------------------------
DisplayClusters PROC
; Display all clusters allocated to a single file.
; Receives: SI contains the offset of the directory entry.
;----------------------------------------------------------
	push ax
	call displayFilename	; display the filename
	mov  ax,[si+1Ah]	; get first cluster
C1:	cmp  ax,0FFFh	; last cluster?
	je   C2	; yes: quit
	mov  bx,10	; choose decimal radix
	call WriteDec	; display the number
	call writeSpace	; display a space
	call next_FAT_entry	; returns cluster # in AX
	jmp  C1	; find next cluster
C2:	call Crlf
	pop  ax
	ret
DisplayClusters ENDP

;----------------------------------------------------------
WriteSpace PROC
; Write a single space to standard output.
;----------------------------------------------------------
	push ax
	mov  ah,2	; function: display character
	mov  dl,20h	; 20h = space
	int  21h
	pop  ax
	ret
WriteSpace ENDP


;----------------------------------------------------------
Next_FAT_entry PROC
; Find the next cluster in the FAT.
; Receives: AX = current cluster number
; Returns: AX = new cluster number
;----------------------------------------------------------
	push bx	; save regs
	push cx
	mov  bx,ax	; copy the number
	shr  bx,1	; divide by 2
	add  bx,ax	; new cluster OFFSET
	mov  dx,fattable[bx]	; DX = new cluster value
	shr  ax,1	; old cluster even?
	jc   E1	; no: keep high 12 bits
	and  dx,0FFFh	; yes: keep low 12 bits
	jmp  E2
E1:	shr  dx,4	; shift 4 bits to the right
E2:	mov  ax,dx	; return new cluster number
	pop  cx	; restore regs
	pop  bx
	ret
Next_FAT_entry ENDP

;----------------------------------------------------------
DisplayFilename PROC
; Display the file name.
;----------------------------------------------------------
	mov  byte ptr [si+11],0 	; SI points to filename
	mov  dx,si
	call Writestring
	mov  ah,2               	; display a space
	mov  dl,20h
	int  21h
	ret
DisplayFilename ENDP

;----------------------------------------------------------
Initialize PROC
; Set upt DS, clear screen, display a heading.
;----------------------------------------------------------
	mov  ax,@data
	mov  ds,ax
	call ClrScr
	mov  dx,OFFSET heading	; display program heading
	call Writestring
	ret
Initialize ENDP
END main