; Using PeekConsoleInput          (PeekInput.asm)

COMMENT @
This program shows how to get single key input by
calling PeekConsoleInput.
Thanks to Richard Stam for his first version of this code.

More analysis is still to be done on this topic, because the
current version does not recognize keyboard combinations such as
Ctrl-F1 or Alt-F2. The Ctrl and Shift keys are returned as separate
keystrokes in themselves. The MS-Windows virtual keycodes do not
seem to include these combinations.
@

INCLUDE Irvine32.inc
INCLUDE Macros.inc

EVENT_BUFFER_SIZE = 1

.data
inputKey    BYTE ?
stdInHandle DWORD ?

.code
main PROC
	;For testing purposes only. Irvine32.lib already does this.
	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov stdInHandle,eax

	;Empties the console input buffer. All console programs
	;put a FOCUS_EVENT in the buffer when the program starts
	;Later, we'll add this to the Initialize proc in Irvine32.lib.
	INVOKE FlushConsoleInputBuffer, stdInHandle

L1:
	mov  eax,100		; sleep, to allow OS timeslicing
	call Delay
	call ReadKey_		; not the one in Irvine32 library
	jz   L1			; no key pressed yet

keyPressed:
	mWrite "Virtual key code:  "
	mShow  DX,hn
	mWrite "Scan code: "
	mShow  AH,hn

	call Crlf

	exit
main ENDP

;------------------------------------------------------
ReadKey_ PROC
;
; Checks the console input buffer for a pending keystroke.
; If a key is waiting, ZF=0, the 8-bit keyboard scan code
; is returned in AH, and the key is returned in AL.
; Otherwise, ZF=1. The return values of this function are
; identical to INT 16h Function 11h, documented on page 533.
;
; Sample call:
; 	call ReadKey
; 	jz   NoKeyWaiting	; no key in buffer
;	mov  scanCode,ah
;   mov  ASCIICode,al
;
; Note: The virtual key code and virtual scan code in the
; KEY_EVENT_RECORD actually return 16-bit device-indepent
; values. But since Irvine32.lib assumes 8-bit OEM characters,
; we're just returning 8-bit values here.
;
;------------------------------------------------------
NUM_KEYS = 1
CTRL_KEY = 11h
repeatCount TEXTEQU <BYTE PTR [keybuf+4]>
virtualKeyCode TEXTEQU <WORD PTR [keybuf+10]>
scanCode TEXTEQU <[keybuf+12]>
asciiCode TEXTEQU <[keybuf+14]>

.data
; make the input buffer large enough to hold multiple input events
keybuf BYTE 50 DUP(0)
recordsRead DWORD ?			; number of records read
.code
	INVOKE PeekConsoleInput, stdInHandle,
	  ADDR keybuf,			; address of input buffer
	  1,					; num records to read
	  ADDR recordsRead		; num records read

	cmp recordsRead,0		; equals 1 when key pressed
	je  quit				; ZF=1 means no input found

	;Empties the console input buffer.
	INVOKE FlushConsoleInputBuffer, stdInHandle

	;Was the event a keyboard input?
	cmp  WORD PTR keybuf,KEY_EVENT	; key pressed?
	jne  NoKey			; no

	;Optional debugging: display the input buffer
	;mDumpMem OFFSET keybuf, 15, TYPE BYTE

Check_Count:
	cmp  repeatCount,1		; repeat count = 1?
	jne  NoKey			; no

Get_Codes:
	mov ah,scanCode		; return the scan code
	mov al,asciiCode		; return the ascii code
	mov dx,virtualKeyCode
	or  dx,dx				; clear the Zero flag
	jmp quit

NoKey:
	test eax,0			; set ZF=1 and quit

quit:
	ret
ReadKey_ ENDP


END main
