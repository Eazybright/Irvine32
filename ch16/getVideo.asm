TITLE Get Video Information               (getVideo.asm)

; This program retrieves information about the current video
; display mode as well as a pointer to a table describing the
; characteristics and capabilities of the video display adapter
; and monitor. Information about INT 10h function 1Bh may be found
; in "Advanced MS-DOS, 2nd Edition", by Ray Duncan, pages 531-532.
; Last update: 06/01/2006

INCLUDE Irvine16.inc
INCLUDE Macros.inc

COMMENT !    ; (CursorPosStruc and VideoInfoStruc are defined in Irvine16.inc)
CursorPosStruc STRUCT
	Ycoord BYTE ?
	Xcoord BYTE ?
CursorPosStruc ENDS

VideoInfoStruc STRUC
	supportedInfoPtr     DWORD ?
	videoMode            BYTE ?
	numCharColumns       WORD ?
	videoBufferLen       WORD ?
	videoBufferStartPtr  WORD ?
	cursors CursorPosStruc 8 DUP(<>)	; video pages 0-7
	cursorStartLine      BYTE ?
	cursorEndLine        BYTE ?
	activeDisplayPage    BYTE ?
	adapterBasePortAddr  WORD ?
	currentRegister3B8or3D8 BYTE ?
	currentRegister3B9or3D9 BYTE ?
	numCharRows          BYTE ?
	characterScanHeight  WORD ?
	activeDisplayCode    BYTE ?
	inactiveDisplayCode  BYTE ?
	numberOfColors       WORD ?
	numberOfVideoPages   BYTE ?
	numberOfScanLines    WORD ?
	primaryCharBlock     BYTE ?
	secondaryCharBlock   BYTE ?
	miscStateInfo        BYTE ?,BYTE 3 DUP(?)
	videoMemAvail        BYTE ?
	savePointerStateInfo BYTE ?,BYTE 13 DUP(?)
VideoInfoStruc ENDS
!

.data
videoInfo VideoInfoStruc <>

.code
main PROC
	mov  ax,@data
	mov  ds,ax
	call ClrScr

	mov  ah,1Bh	; get Video Information
	mov  bx,0	; always zero
	push ds	; copy DS to ES
	pop  es
	mov  di,OFFSET videoInfo	; ES:DI points to videoInfo
	int  10h
	cmp  al,1Bh	; check return value in AL
	jne  notSupported

	mWrite "Character rows: "
	movzx eax,videoInfo.numCharRows
	call WriteDec
	call Crlf

	mWrite "Character columns: "
	movzx eax,videoInfo.numCharColumns
	call WriteDec
	call Crlf
	jmp  finished

notSupported:
	mWrite <"Video function 1Bh is not supported on this computer",0dh,0ah>

finished:
	exit
main ENDP
END main
