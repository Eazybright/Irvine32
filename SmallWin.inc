.NOLIST
; Include file for Calling Windows API Functions      (SmallWin.inc)

; Recent updates:
;  7/16/05  (printf, scanf)

; To enable columns to line up properly, set your text editor's Tab
; settings to 5, 35, and 40.

.686P		; Pentium Pro or later
.MODEL flat, stdcall
.STACK 4096

;--------- my own constants --------------
DO_NOT_SHARE = 0
NULL = 0
TRUE = 1
FALSE = 0
TAB = 9		; ASCII code for Horiz Tab
;-----------------------------------------

HANDLE TEXTEQU <DWORD>		; used in Win32 API documentation

; Win32 Console handles
STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11		; predefined Win API constant
STD_ERROR_HANDLE EQU -12

;  Input Mode flags (used by GetConsoleMode & SetConsoleMode):
ENABLE_PROCESSED_INPUT = 1
ENABLE_LINE_INPUT      = 2
ENABLE_ECHO_INPUT      = 4
ENABLE_WINDOW_INPUT    = 8
ENABLE_MOUSE_INPUT     = 16

; Event constants
KEY_EVENT       =  1
MOUSE_EVENT     =  2
WINDOW_BUFFER_SIZE_EVENT = 4          ; window change event record
MENU_EVENT      = 8                   ; menu event record
FOCUS_EVENT     = 16                  ; focus change

; ControlKeyState constants (used by ReadKey)
KEY_MASKS  = 00011111b		; Mask if any Shift/Ctrl/Alt flag is set
ALT_MASK   = 00000011b		; Left and right Alt key flags
CTRL_MASK  = 00001100b		; Left and right Alt key flags
SHIFT_MASK = 00010000b		; Left or right Shift key flag

KBDOWN_FLAG = 00000001h		; Bit set for press, clear for release

;  Output mode flags  (used by GetConsoleMode & SetConsoleMode):
ENABLE_PROCESSED_OUTPUT    = 1
ENABLE_WRAP_AT_EOL_OUTPUT  = 2

; Constants found in WINNT.H
FILE_SHARE_READ                 = 1
FILE_SHARE_WRITE                = 2
FILE_SHARE_DELETE               = 4

FILE_ATTRIBUTE_READONLY         = 1
FILE_ATTRIBUTE_HIDDEN           = 2
FILE_ATTRIBUTE_SYSTEM           = 4
FILE_ATTRIBUTE_DIRECTORY        = 10h
FILE_ATTRIBUTE_ARCHIVE          = 20h
FILE_ATTRIBUTE_DEVICE           = 40h
FILE_ATTRIBUTE_NORMAL           = 80h
FILE_ATTRIBUTE_TEMPORARY        = 100h
FILE_ATTRIBUTE_SPARSE_FILE      = 200h
FILE_ATTRIBUTE_REPARSE_POINT    = 400h
FILE_ATTRIBUTE_COMPRESSED       = 800h
FILE_ATTRIBUTE_OFFLINE          =    1000h
FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 2000h
FILE_ATTRIBUTE_ENCRYPTED           = 4000h

FILE_READ_DATA = 1
FILE_WRITE_DATA = 2
FILE_APPEND_DATA = 4
FILE_DELETE_CHILD = 40h

GENERIC_READ     = 80000000h
GENERIC_WRITE    = 40000000h
GENERIC_EXECUTE  = 20000000h
GENERIC_ALL      = 10000000h

; Memory allocation constants
HEAP_NO_SERIALIZE              = 00000001h
HEAP_GROWABLE                  = 00000002h
HEAP_GENERATE_EXCEPTIONS       = 00000004h
HEAP_ZERO_MEMORY               = 00000008h
HEAP_REALLOC_IN_PLACE_ONLY     = 00000010h

; Error Handler Variables
FORMAT_MESSAGE_ALLOCATE_BUFFER     = 100h
FORMAT_MESSAGE_FROM_SYSTEM         = 1000h

;------------- Message Box Constants ---------------

; Icons:
MB_ICONHAND            = 10h
MB_ICONQUESTION        = 20h
MB_ICONEXCLAMATION     = 30h
MB_ICONASTERISK        = 40h
MB_USERICON            = 80h
MB_ICONWARNING         = MB_ICONEXCLAMATION
MB_ICONERROR           = MB_ICONHAND
MB_ICONINFORMATION     = MB_ICONASTERISK
MB_ICONSTOP            = MB_ICONHAND

; Buttons:
MB_OK         = 0
MB_OKCANCEL   = 1
MB_ABORTRETRYIGNORE = 2
MB_YESNOCANCEL = 3
MB_YESNO       = 4
MB_RETRYCANCEL = 5
MB_CANCELTRYCONTINUE = 6
MB_HELP        =  4000h          ; does not close the window

; Select the default button:
MB_DEFBUTTON1 = 0
MB_DEFBUTTON2 = 100h
MB_DEFBUTTON3 = 200h
MB_DEFBUTTON4 = 300h

; Modal control buttons:
MB_APPLMODAL     =  0
MB_SYSTEMMODAL   =  1000h	; dialog floats above all windows
MB_TASKMODAL     =  2000h

; Return values:
IDOK               = 1
IDCANCEL           = 2
IDABORT            = 3
IDRETRY            = 4
IDIGNORE           = 5
IDYES              = 6
IDNO               = 7
IDCLOSE            = 8
IDHELP             = 9
IDTRYAGAIN         = 10
IDCONTINUE         = 11
IDTIMEOUT          = 32000

;------------------ From winbase.h ----------------------------
CREATE_NEW         = 1
CREATE_ALWAYS      = 2
OPEN_EXISTING      = 3
OPEN_ALWAYS        = 4
TRUNCATE_EXISTING  = 5

FILE_BEGIN         =  0
FILE_CURRENT       =  1
FILE_END           =  2

INVALID_HANDLE_VALUE = -1

;--------------------From wincon.h ---------------------------

; ControlKeyState flags

RIGHT_ALT_PRESSED    = 0001h      ; the right alt key is pressed.
LEFT_ALT_PRESSED     = 0002h      ; the left alt key is pressed.
RIGHT_CTRL_PRESSED   = 0004h      ; the right ctrl key is pressed.
LEFT_CTRL_PRESSED    = 0008h      ; the left ctrl key is pressed.
SHIFT_PRESSED        = 0010h      ; the shift key is pressed.
NUMLOCK_ON           = 0020h      ; the numlock light is on.
SCROLLLOCK_ON        = 0040h      ; the scrolllock light is on.
CAPSLOCK_ON          = 0080h      ; the capslock light is on.
ENHANCED_KEY         = 0100h      ; the key is enhanced.

;---------------------- from WinUser.h -------------------------

VK_NUMLOCK  =   90h
VK_SCROLL   =   91h
VK_LSHIFT   =   0A0h
VK_RSHIFT   =   0A1h
VK_LCONTROL =   0A2h
VK_RCONTROL =   0A3h
VK_LMENU    =   0A4h
VK_RMENU    =   0A5h

;----------------------------------------------------------------

exit EQU <INVOKE ExitProcess,0>		; exit program

;======================================================
;                     ALIASES
;======================================================
; The following Win32 API functions have an
; extra "A" at the end of their name, so they are
; redefined here with text macros:

CreateFile 	EQU <CreateFileA>
FormatMessage   	EQU <FormatMessageA>
GetCommandLine	EQU <GetCommandLineA>
MessageBox      	EQU <MessageBoxA>
PeekConsoleInput	EQU <PeekConsoleInputA>
ReadConsole 	EQU <ReadConsoleA>
ReadConsoleInput	EQU <ReadConsoleInputA>
SetConsoleTitle	EQU <SetConsoleTitleA>
WriteConsole 	EQU <WriteConsoleA>
WriteConsoleOutputCharacter 	EQU <WriteConsoleOutputCharacterA>
wsprintf 		EQU <wsprintfA>

;=======================================================
; Standard Windows Structure defintions:
;=======================================================

COORD STRUCT
	X WORD ?
	Y WORD ?
COORD ENDS

SYSTEMTIME STRUCT
	wYear WORD ?
	wMonth WORD ?
	wDayOfWeek WORD ?
	wDay WORD ?
	wHour WORD ?
	wMinute WORD ?
	wSecond WORD ?
	wMilliseconds WORD ?
SYSTEMTIME ENDS

; Date and time, measured in 100ns intervals
; since January 1, 1601.
FILETIME STRUCT
    loDateTime DWORD ?
    hiDateTime DWORD ?
FILETIME ENDS

SMALL_RECT STRUCT
  Left     WORD ?
  Top      WORD ?
  Right    WORD ?
  Bottom   WORD ?
SMALL_RECT ENDS

CONSOLE_CURSOR_INFO STRUCT
  dwSize   DWORD ?
  bVisible DWORD ?
CONSOLE_CURSOR_INFO ENDS

CONSOLE_SCREEN_BUFFER_INFO STRUCT
  dwSize                COORD <>
  dwCursorPosition      COORD <>
  wAttributes           WORD ?
  srWindow              SMALL_RECT <>
  dwMaximumWindowSize   COORD <>
CONSOLE_SCREEN_BUFFER_INFO ENDS

KEY_EVENT_RECORD STRUCT
	bKeyDown          DWORD ?
	wRepeatCount      WORD  ?
	wVirtualKeyCode   WORD  ?
	wVirtualScanCode  WORD  ?
	UNION uChar
	  UnicodeChar     WORD  ?
	  AsciiChar       BYTE  ?
	ENDS
	dwControlKeyState DWORD ?
KEY_EVENT_RECORD ENDS

MOUSE_EVENT_RECORD STRUCT
	dwMousePosition         COORD <>
	dwButtonState           DWORD ?
	dwMouseControlKeyState  DWORD ?  
	dwEventFlags            DWORD ?
MOUSE_EVENT_RECORD ENDS

WINDOW_BUFFER_SIZE_RECORD STRUCT
	dwSize COORD <>
WINDOW_BUFFER_SIZE_RECORD ENDS

MENU_EVENT_RECORD STRUCT
	dwCommandId DWORD ?		; reserved
MENU_EVENT_RECORD ENDS

FOCUS_EVENT_RECORD STRUCT
  bSetFocus DWORD ?
FOCUS_EVENT_RECORD ENDS

INPUT_RECORD STRUCT
	EventType WORD ?
	ALIGN DWORD	; align next field on doubleword boundary
	UNION Event
		KEY_EVENT_RECORD <>
		MOUSE_EVENT_RECORD <>
		WINDOW_BUFFER_SIZE_RECORD <>
		MENU_EVENT_RECORD <>
		FOCUS_EVENT_RECORD <>
	ENDS
INPUT_RECORD ENDS

;==========================================================
;                   FUNCTION PROTOTYPES
;==========================================================

CloseHandle PROTO,		; close file handle
	hObject:DWORD

CreateFile PROTO,		; create new file
	lpFilename:PTR BYTE,		; ptr to filename
	dwDesiredAccess:DWORD,		; access mode
	dwShareMode:DWORD,		; share mode
	lpSecurityAttributes:DWORD,  		; pointer to security attributes
	dwCreationDisposition:DWORD,		; file creation options
	dwFlagsAndAttributes:DWORD,		; file attributes
	hTemplateFile:DWORD		; handle to template file

ExitProcess PROTO,                  	; exit program
	dwExitCode:DWORD		; return code

FileTimeToSystemTime PROTO,		; convert FILETIME to SYSTEMTIME
	lpFileTime:PTR FILETIME,
	lpSystemTime:PTR SYSTEMTIME
	
FileTimeToDosDateTime PROTO,		; converts a Win32 file time to MS-DOS date/time
	lpFileTime:PTR FILETIME,
	lpFatDate:PTR WORD,
	lpFatTime:PTR WORD

FormatMessage PROTO,		; format a message
	dwFlags:DWORD,		; formatting options
	lpSource:DWORD,		; location of message definition
	dwMsgID:DWORD,		; message identifier
	dwLanguageID:DWORD,		; language identifier
	lpBuffer:PTR BYTE,		; pointer to buffer receiving string
	nSize:DWORD,		; buffer size
	va_list:DWORD		; pointer to list of arguments
	
FlushConsoleInputBuffer PROTO,		; flush the input buffer
	hConsoleInput:HANDLE		; standard input handle

GetCommandLine PROTO		; returns pointer to command-line string

GetConsoleCP PROTO		; returns code page ID in eax

GetConsoleCursorInfo PROTO,
	hConsoleOutput:HANDLE,			; console output handle
	lpConsoleCursorInfo:PTR CONSOLE_CURSOR_INFO	; cursor information

GetConsoleMode PROTO,
	hConsoleHandle:HANDLE,		; input or output handle
	lpMode:PTR DWORD		; pointer to dword containing flags

GetConsoleScreenBufferInfo PROTO,
	hConsoleOutput:HANDLE,		; handle to screen buffer
	lpConsoleScreenBufferInfo:PTR CONSOLE_SCREEN_BUFFER_INFO

GetFileTime PROTO,		; get date/time stamp of a file
	hFile:HANDLE,
	pCreationTime:PTR FILETIME,
	pLastAccessTime:PTR FILETIME,
	pLastWriteTime:PTR FILETIME
	
GetKeyState PROTO,		; get state of keyboard keys (see Ch11\keybd.asm) 
	nVirtKey:DWORD

GetLastError PROTO		; get most recent error return value

GetLocalTime PROTO,		; system time, adjusted for local time zone
	lpSystemTime:PTR SYSTEMTIME		; ptr to SYSTEMTIME object

GetNumberOfConsoleInputEvents PROTO,	; get number of unread records
	hConsoleInput:HANDLE,		; input handle
	lpCount:PTR DWORD		; pointer to counter

GetStdHandle PROTO,               	; get standard handle
	nStdHandle:HANDLE  		; type of console handle

GetSystemTime PROTO,		; returns the system time
	lpSystemTime:PTR SYSTEMTIME		; ptr to SYSTEMTIME object

GetTickCount PROTO		; get elapsed milliseconds
				; since computer was turned on

GetProcessHeap PROTO   		; Get the current process heap handle

HeapAlloc PROTO,
	hHeap:HANDLE,		; handle to private heap block
	dwFlags:DWORD,		; heap allocation control flags
	dwBytes:DWORD		; number of bytes to allocate

HeapCreate PROTO,
	flOptions:DWORD,		; heap allocation options
	dwInitialSize:DWORD,		; initial heap size, in bytes
	dwMaximumSize:DWORD		; maximum heap size, in bytes

HeapDestroy PROTO,
	hHeap:HANDLE		; heap handle

HeapFree PROTO,
	hHeap:HANDLE,		; handle to heap with memory block
	dwFlags:DWORD,		; heap free options
	lpMem:DWORD		; pointer to block to be freed

HeapSize PROTO,
	hHeap:HANDLE,		; handle to heap
	dwFlags:DWORD,		; heap size options
	pMem:DWORD		; pointer to memory block

LocalFree PROTO,		; free up local memory, using its handle
	hMem:HANDLE
	
MessageBoxA PROTO,		; displays a pop-up message box
	hWnd:DWORD,		; handle to window (can be null)
	lpText:PTR BYTE,		; string for inside of dialog box
	lpCaption:PTR BYTE,		; string for dialog box title
	uType:DWORD		; contents and behavior of the dialog

PeekConsoleInput PROTO,
	hConsoleInput:HANDLE,		; input handle
	lpBuffer:PTR BYTE,		; pointer to buffer
	nLength:DWORD,    		; number of chars to read
	lpNumberOfEventsRead:PTR DWORD  	; ptr to number of events read
	
printf PROTO C,		; Std C library function
	format:PTR BYTE, args:VARARG		; (in libc.lib)

ReadConsole PROTO,
	hConsoleInput:HANDLE,              ; input handle
	lpBuffer:PTR BYTE,                	; pointer to buffer
	nNumberOfBytesToRead:DWORD,    	; number of chars to read
	lpNumberOfCharsRead:PTR DWORD,  	; ptr to number of bytes read
	lpReserved:DWORD               	; (not used)

ReadConsoleInput PROTO,
	hConsoleInput:HANDLE,		; input handle
	lpBuffer:PTR INPUT_RECORD,		; ptr to input record
	nLength:DWORD,		; request number of recs
	lpNumberOfEventsRead:PTR DWORD	; ptr to number of bytes read

ReadFile PROTO,		; read buffer from input file
	hFile:HANDLE,		; input handle
	lpBuffer:PTR BYTE,		; ptr to buffer
	nNumberOfBytesToRead:DWORD,		; num bytes to read
	lpNumberOfBytesRead:PTR DWORD,	; bytes actually read
	lpOverlapped:PTR DWORD		; ptr to asynchronous info

scanf PROTO C,		; Std C library function
	format:PTR BYTE, args:VARARG		; (in libc.lib)

SetConsoleCursorInfo PROTO,
	hConsoleOutput:HANDLE,		 ; output handle
	lpConsoleCursorInfo:PTR CONSOLE_CURSOR_INFO	; cursor information

SetConsoleCursorPosition PROTO,
	hConsoleOutput:HANDLE,		; output handle
	dwCursorPosition:COORD		; screen X,Y coordinates

SetConsoleMode PROTO,
	hConsoleHandle:HANDLE,		; output handle
	dwMode:DWORD		; console mode flags

SetConsoleScreenBufferSize PROTO,
	hConsoleOutput:HANDLE,		; handle to screen buffer
	dwSize:COORD		; new screen buffer size

SetConsoleTextAttribute PROTO,
	hConsoleOutput:HANDLE,		; output handle
	wAttributes:WORD		; color attribute (fixed 6/20/05)

SetConsoleTitle PROTO,		; set console window title
	lpConsoleTitle:PTR BYTE		; points to string

SetConsoleWindowInfo PROTO,		; set position of console window
	hConsoleOutput:HANDLE,		; screen buffer handle
	bAbsolute:DWORD,		; coordinate type
	lpConsoleWindow:PTR SMALL_RECT	; ptr to window rectangle

SetFilePointer PROTO,		; set the file pointer position
	hFile:HANDLE,		; file handle
	lDistanceToMove:SDWORD,		; bytes to move pointer
	lpDistanceToMoveHigh:PTR SDWORD,	; ptr to bytes to move, high
	dwMoveMethod:DWORD		; starting point

SetLocalTime PROTO,		; set the system's local date and time
	lpSystemTime:PTR SYSTEMTIME		; ptr to SYSTEMTIME structure

Sleep PROTO,	   	; sleeep for n milliseconds
	dwMilliseconds:DWORD

SystemTimeToFileTime PROTO,		; Convert a SYSTEMTIME structure
	lpSystemTime:PTR SYSTEMTIME,		; to a FILETIME structure
	lpFileTime:PTR FILETIME

WriteConsole PROTO,		; write a buffer to the console
	hConsoleOutput:HANDLE,		; output handle
	lpBuffer:PTR BYTE,		; pointer to buffer
	nNumberOfCharsToWrite:DWORD,		; size of buffer
	lpNumberOfCharsWritten:PTR DWORD,		; ptr to number of bytes written
	lpReserved:DWORD		; (not used)

WriteConsoleOutputCharacter PROTO,
	hConsoleOutput:HANDLE,		; console output handle
	lpCharacter:PTR BYTE,		; pointer to buffer
	nLength:DWORD,		; size of buffer
	dwWriteCoord:COORD,		; first cell coordinates
	lpNumberOfCharsWritten:PTR DWORD	; output count

WriteConsoleOutputAttribute PROTO,
	hConsoleOutput:HANDLE,		; output handle
	lpAttribute:PTR WORD,		; write attributes
	nLength:DWORD,		; number of cells
	dwWriteCoord:COORD,		; first cell coordinates
	lpNumberOfAttrsWritten:PTR DWORD	; number of cells written

WriteFile PROTO,		; write buffer to output file
	hFile:HANDLE,		; output handle
	lpBuffer:PTR BYTE,		; pointer to buffer
	nNumberOfBytesToWrite:DWORD,		; size of buffer
	lpNumberOfBytesWritten:PTR DWORD,	; num bytes written
	lpOverlapped:PTR DWORD		; ptr to asynchronous info

wsprintf PROTO NEAR C,
	lpOut:PTR BYTE,		; output buffer
	lpFmt:PTR BYTE,		; format-control string
	vars :VARARG		; optional arguments

.LIST