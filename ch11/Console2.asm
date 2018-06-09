; Console Demo #2                (Console2.asm)

; Demonstration of SetConsoleCursorPosition,
; GetConsoleCursorInfo, SetConsoleCursorInfo,
; SetConsoleScreenBufferSize, SetConsoleCursorPosition,
; SetConsoleTitle, and GetConsoleScreenBufferInfo.

INCLUDE SmallWin.inc

.data
outHandle    DWORD ?
scrSize COORD <120,50>
xyPos COORD <20,5>
consoleInfo CONSOLE_SCREEN_BUFFER_INFO <>
cursorInfo CONSOLE_CURSOR_INFO <>
titleStr BYTE "Console2 Demo Program",0

.code
main PROC
  ; Get Console output handle.
	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	mov outHandle,eax

	; Get console cursor information.
	INVOKE GetConsoleCursorInfo, outHandle,
	  ADDR cursorInfo

	; Set console cursor size to 75%
	mov cursorInfo.dwSize,75
	INVOKE SetConsoleCursorInfo, outHandle,
	  ADDR cursorInfo

	; Set the screen buffer size.
	INVOKE SetConsoleScreenBufferSize,
	  outHandle,scrSize

  	; Set the cursor position to (20,5).
	INVOKE SetConsoleCursorPosition, outHandle, xyPos

  	; Set the console window's title.
	INVOKE SetConsoleTitle, ADDR titleStr

	; Get screen buffer & window size information.
	INVOKE GetConsoleScreenBufferInfo, outHandle,
	  ADDR consoleInfo

	INVOKE ExitProcess,0
main ENDP
END main