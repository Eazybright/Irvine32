; Showing the Time                (ShowTime.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.

INCLUDE Irvine32.inc

Comment @
Definitions copied from SmallWin.inc:

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
---------------------------------------- @

.data
sysTime SYSTEMTIME <>
XYPos   COORD <10,5>
consoleHandle DWORD ?
colonStr BYTE ":",0
TheTimeIs BYTE "The time is ",0

.code
main PROC
; Get the standard output handle for the Win32 Console.
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle,eax

; Set the cursor position and get the local time zone.
	INVOKE SetConsoleCursorPosition, consoleHandle, XYPos
	INVOKE GetLocalTime,ADDR sysTime

	mov   edx,OFFSET TheTimeIs		; "The time is "
	call  WriteString

; Display the system time (hh:mm:ss).
	movzx eax,sysTime.wHour			; hours
	call  WriteDec
	mov   edx,offset colonStr		; ":"
	call  WriteString
	movzx eax,sysTime.wMinute		; minutes
	call  WriteDec
	call  WriteString				; ":"
	movzx eax,sysTime.wSecond		; seconds
	call  WriteDec
	call Crlf
	exit
main ENDP
END main