; Irvine16.inc - Include file for programs using
; the Irvine16.lib (Real-address mode library).

; Last update: 7/29/05

.NOLIST

.model small,STDCALL
.stack 200h
.386

Clrscr PROTO
Crlf PROTO
Delay PROTO
DumpMem PROTO
DumpRegs PROTO
GetCommandtail PROTO
GetMaxXY PROTO
GetMseconds PROTO
Gotoxy PROTO
IsDigit PROTO
Randomize PROTO
RandomRange PROTO
Random32 PROTO
ReadHex PROTO
ReadInt PROTO
ReadChar PROTO
ReadFloat PROTO
ReadString PROTO
SetTextColor PROTO
ShowFPUStack PROTO
WaitMsg PROTO
WriteBin PROTO
WriteBinB PROTO
WriteChar PROTO
WriteDec PROTO
WriteHex PROTO
WriteHexB PROTO
WriteInt PROTO
WriteString PROTO
WriteFloat PROTO

; Copy a source string to a target string.
Str_copy PROTO,
 	source:PTR BYTE,
 	target:PTR BYTE

; Return the length of a null-terminated string..
Str_length PROTO,
	pString:PTR BYTE

; Compare string1 to string2. Set the Zero and
; Carry flags in the same way as the CMP instruction.
Str_compare PROTO,
	string1:PTR BYTE,
	string2:PTR BYTE

; Trim a given trailing character from a string.
; The second argument is the character to trim.
Str_trim PROTO,
	pString:PTR BYTE,
	char:BYTE

; Convert a null-terminated string to upper case.
Str_ucase PROTO,
	pString:PTR BYTE


exit EQU <.EXIT>
@cmdline EQU <OFFSET __98765765cmdline>

;-----------------------------------
; STANDARD 4-bit COLOR DEFINITIONS
;-----------------------------------
black        = 0000b
blue         = 0001b
green        = 0010b
cyan         = 0011b
red          = 0100b
magenta      = 0101b
brown        = 0110b
lightGray    = 0111b
gray         = 1000b
lightBlue    = 1001b
lightGreen   = 1010b
lightCyan    = 1011b
lightRed     = 1100b
lightMagenta = 1101b
yellow       = 1110b
white        = 1111b

; Alternate color constants (used in Chapter 15, printints 1-2)
; added 1/8/2003

BLACK        = 0000b
BLUE         = 0001b
GREEN        = 0010b
CYAN         = 0011b
RED          = 0100b
MAGENTA      = 0101b
BROWN        = 0110b
LIGHT_GRAY   = 0111b
GRAY         = 1000b
LIGHT_BLUE   = 1001b
LIGHT_GREEN  = 1010b
LIGHT_CYAN   = 1011b
LIGHT_RED    = 1100b
LIGHT_MAGENTA = 1101b
YELLOW       = 1110b
WHITE        = 1111b

;-------------------------------------------------
; SYMBOLS
;-------------------------------------------------

; Constants related to creating and opening files. From the Windows 9x SDK.

FILE_CREATE	= 0010h
FILE_OPEN 	= 0001h
FILE_TRUNCATE	= 0002h

ACTION_OPENED 	= 0001h
ACTION_CREATED_OPENED 	= 0002h
ACTION_REPLACED_OPENED 	= 0003h

OPEN_SHARE_COMPATIBLE 	= 0000h
OPEN_SHARE_DENYREADWRITE 	= 0010h
OPEN_SHARE_DENYWRITE 	= 0020h
OPEN_SHARE_DENYREAD 	= 0030h
OPEN_SHARE_DENYNONE 	= 0040h

OPEN_FLAGS_NOINHERIT	= 0080h
OPEN_FLAGS_NO_BUFFERING	= 0100h
OPEN_FLAGS_NO_COMPRESS	= 0200h
OPEN_FLAGS_ALIAS_HINT	= 0400h
OPEN_FLAGS_NOCRITERR	= 2000h
OPEN_FLAGS_COMMIT	= 4000h

OPEN_ACCESS_READONLY 	= 0000h
OPEN_ACCESS_WRITEONLY 	= 0001h
OPEN_ACCESS_READWRITE 	= 0002h
OPEN_ACCESS_RO_NOMODLASTACCESS 	= 0004h

_A_NORMAL 	= 0000h
_A_RDONLY 	= 0001h
_A_HIDDEN 	= 0002h
_A_SYSTEM 	= 0004h
_A_VOLID 		= 0008h
_A_ARCH 		= 0020h

;--------------------------------------------------
; Structures
;--------------------------------------------------

; CursorPosStruc and VideoInfoStruc are used by INT 10h, Function 1Bh
; (Get Video Information).See the GetMaxXY procedure for details.
; (Added 10/21/2002)

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
	miscStateInfo        BYTE ?
	                     BYTE 3 DUP(?)
	videoMemAvail        BYTE ?
	savePointerStateInfo BYTE ?
	                     BYTE 13 DUP(?)
VideoInfoStruc ENDS



; ExtGetDskFreSpcStruc is used by INT 21h Function 7303h
; (Get Disk Free Space):

ExtGetDskFreSpcStruc STRUC
    StructSize                WORD  ?
    Level                     WORD  ?
    SectorsPerCluster         DWORD ?
    BytesPerSector            DWORD ?
    AvailableClusters         DWORD ?
    TotalClusters             DWORD ?
    AvailablePhysSectors      DWORD ?
    TotalPhysSectors          DWORD ?
    AvailableAllocationUnits  DWORD ?
    TotalAllocationUnits      DWORD ?
    Rsvd                      DWORD 2 DUP (?)
ExtGetDskFreSpcStruc ENDS

; TimeRecord structure. Will be copied from an include file.

TimeRecord STRUCT
	hours    BYTE ?
	minutes  BYTE ?
	seconds  BYTE ?
	hhss     BYTE ?
TimeRecord ENDS

; This structure is returned by the FSTSW
; instruction in real-address mode:

FPU_ENVIRON STRUCT
	controlWord     WORD ?
	ALIGN DWORD
	statusWord      WORD ?
	ALIGN DWORD
	tagWord         WORD ?
	ALIGN DWORD
	instrPtrLow     WORD ?
	ALIGN DWORD
	opcodeAndInstrPtrHi  DWORD ?
	operandPtrLow        WORD ?
	ALIGN DWORD
	operandPtrHi         DWORD ?
FPU_ENVIRON ENDS


.LIST