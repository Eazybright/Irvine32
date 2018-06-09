; 64-bit Library (Irvine64.asm)

; Version 1.1, 7/2/2015

COMMENT !
This library was created exlusively for use with the book,
"Assembly Language for Intel-Based Computers", 7th Edition,
by Kip R. Irvine, 2014.

Copyright 2014, Prentice-Hall Publishing. No part of this file may be
reproduced, in any form or by any other means, without permission in writing
from the author or publisher.

Win64 API classifies RAX,RCX,RDX,R8,R9,R10,and R11 as volatile,
so their values are not preserved across API function calls.

Bug fixes:
7/2/2015: corrected the ReadString procedure.


!

; Public procedures:
; Crlf
; Randomize
; Random64
; RandomRange
; ReadInt64
; ReadString
; Str_compare
; Str_copy
; Str_length
; WriteHexB
; WriteHex32
; WriteHex64
; WriteInt64
; WriteString

; This library calls the following external procedures from the Windows API:
GetConsoleMode proto
GetStdHandle proto
ReadConsoleA proto
SetConsoleMode proto
WriteConsole proto
WriteConsoleA proto
GetSystemTime proto				; returns the system time

; Note: Chapter 5 states that:
; RBX, RBP, RDI, RSI, R12, R14, R14, and R15 registers 
; are preserved by the Irvine64 library.

;-------------------------------------------------------------
CheckInit MACRO
;
; Helper macro
; Check to see if the console handles have been initialized
; If not, initialize them now.
;-------------------------------------------------------------
LOCAL exit
	cmp InitFlag,0
	jne exit
	call Initialize
exit:
ENDM

STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11		; predefined Win API constant
TAB = 9							; ASCII code for Horiz Tab

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


; ------------ Shared Data --------------------------------
.data
InitFlag BYTE 0					; initialization flag
consoleInHandle  QWORD ?     	; handle to standard input device
consoleOutHandle QWORD ?     	; handle to standard output device
bytesWritten     QWORD ?     	; number of bytes written
bytesRead        QWORD ?

sysTime SYSTEMTIME <>			; system time structure
crlfstring  byte 0dh,0ah,0
xtable BYTE "0123456789ABCDEF"

.code

;---------------------------------------------------
; Crlf
; Writes an end of line sequence to standard output
;---------------------------------------------------
Crlf proc uses rax rcx rdx 
	mov  rdx,offset crlfstring
	call WriteString
	ret
Crlf endp

;----------------------------------------------------
; Initialize
; Gets the standard console handles for input and output,
; and sets a flag indicating that it has been done.
; Modifies: consoleInHandle, consoleOutHandle, InitFlag
; Receives: nothing
; Returns: nothing
; ----------------------------------------------------
Initialize PROC private uses rax rcx rdx
	sub		rsp,28h				; set aside shadow space + align stack pointer

	mov		rcx,STD_INPUT_HANDLE
	call	GetStdHandle
	mov		[consoleInHandle],rax

	mov		rcx,STD_OUTPUT_HANDLE
	call	GetStdHandle
	mov		[consoleOutHandle],rax
	mov		InitFlag,1
	add		rsp,28h				; restore stack 

	ret
Initialize ENDP

;-----------------------------------------------
IsDigit PROC
;
; Determines whether the character in AL is a
; valid decimal digit.
; Receives: AL = character
; Returns: ZF=1 if AL contains a valid decimal
;   digit; otherwise, ZF=0.
;-----------------------------------------------
	 cmp   al,'0'
	 jb    ID1
	 cmp   al,'9'
	 ja    ID1
	 test  ax,0     		; set ZF = 1
ID1: ret
IsDigit ENDP

;--------------------------------------------------------
ParseInteger64 PROC PRIVATE USES rbx rcx rdx rsi
  LOCAL Lsign:QWORD, saveDigit:QWORD
;
; Internal (private) procedure.
; Converts a string containing a signed decimal integer to
; binary. 
;
; All valid digits occurring before a non-numeric character
; are converted. Leading spaces are ignored, and an optional 
; leading + or - sign is permitted. If the string is blank, 
; a value of zero is returned.
;
; Receives: RDX = string offset, RCX = string length
; Returns:  If OF=0, the integer is valid, and RAX = binary value.
;   If OF=1, the integer is invalid and RAX = 0.
;
;--------------------------------------------------------
.data
overflow_msgL BYTE  " <64-bit signed integer overflow>",0
invalid_msgL  BYTE  " <invalid signed integer format>",0
.code

	mov   Lsign,1                   ; assume number is positive
	mov   rsi,rdx                   ; save offset in RSI

	cmp   rcx,0                     ; length greater than zero?
	jne   L1                        ; yes: continue
	mov   rax,0                     ; no: set return value
	jmp   L10                       ; and exit

; Skip over leading spaces and tabs.

L1:	mov   al,[rsi]         		; get a character from buffer
	cmp   al,' '        		; space character found?
	je	  L1A					; yes: skip it
	cmp	  al,TAB				; TAB found?
	je	  L1A					; yes: skip it
	jmp   L2              		; no: goto next step
	
L1A:
	inc   rsi              		; yes: point to next character
	loop  L1					; continue searching until end of string
	mov	  rax,0					; all spaces?
	jmp   L10					; return 0 as a valid value

; Check for a leading sign.

L2:	cmp   al,'-'                    ; minus sign found?
	jne   L3                        ; no: look for plus sign

	mov   Lsign,-1                  ; yes: sign is negative
	dec   rcx                       ; subtract from counter
	inc   rsi                       ; point to next char
	jmp   L3A

L3:	cmp   al,'+'                    ; plus sign found?
	jne   L3A               			; no: skip
	inc   rsi                       ; yes: move past the sign
	dec   rcx                       ; subtract from digit counter

; Test the first digit, and exit if nonnumeric.

L3A: mov al,[rsi]          			; get first character
	call IsDigit            		; is it a digit?
	jnz  L7A                		; no: show error message

; Start to convert the number.

L4:	mov  rax,0                  	; clear accumulator
	mov  rbx,10						; EBX is the divisor

; Repeat loop for each digit.

L5:	mov  dl,[rsi]           	; get character from buffer
	cmp  dl,'0'             	; character < '0'?
	jb   L9
	cmp  dl,'9'             	; character > '9'?
	ja   L9
	and  rdx,0Fh            	; no: convert to binary

	mov  saveDigit,rdx
	imul rbx               		; RDX:RAX = RAX * RBX
	mov  rdx,saveDigit

	jo   L6                		; quit if overflow detected
	add  rax,rdx            	; add new digit to AX
	jo   L6                 	; quit if overflow
	inc  rsi                	; point to next digit
	jmp  L5                 	; get next digit

; Overflow has occured, unlesss RAX = 8000000000000000h
; and the sign is negative:

L6:	mov  r8,8000000000000000h	; 64-bit immediate operand not permitted in CMP on next line
	cmp  rax,r8
	jne  L7
	cmp  Lsign,-1
    jne  L7                 	; overflow detected
    jmp  L9                 	; the integer is valid

; Select the "integer overflow" messsage.

L7: mov  rdx,OFFSET overflow_msgL
    jmp  L8

; Select the "invalid integer" message.

L7A:
    mov  rdx,OFFSET invalid_msgL

; Display the error message pointed to by RDX and set the Overflow flag.

L8:	call WriteString
    call Crlf
    mov  al,127
    add  al,1                	; set Overflow flag
    mov  rax,0              	; set return value to zero
    jmp  L10                	; and exit

; IMUL leaves the Sign flag in an undeterminate state, so the OR instruction
; determines the sign of the integer in RAX.
L9:	imul Lsign                  ; RAX = RAX * sign
    or   rax,rax              	; determine the number's Sign

L10:ret
ParseInteger64 ENDP

;--------------------------------------------------------------
Random64  PROC
;
; Generates an unsigned pseudo-random 64-bit integer
;   in the range 0 - FFFFFFFFFFFFFFFFh.
; Receives: nothing
; Returns: RAX = random integer
;--------------------------------------------------------------
.data
seed  QWORD 1
.code
	  push  rdx
	  mov   rax, 343FDh
	  imul  seed
	  add   rax, 269EC3h
	  mov   seed, rax    ; save the seed for the next call
	  ror   rax,8        ; rotate out the lowest digit 
	  pop   rdx

	  ret
Random64  ENDP

;--------------------------------------------------------
Randomize PROC
;
; Re-seeds the random number generator with the current time
; in seconds. Calls GetSystemTime, which is accurate to 10ms.
; Receives: nothing
; Returns: nothing
;--------------------------------------------------------
	  push   rax		; preserve the volatile registers
	  push   rcx
	  push   rdx

	  mov    rcx,OFFSET sysTime	
	  call   GetSystemTime
	  movzx  rax,sysTime.wMilliseconds
	  mov    seed,rax

	  pop	 rdx
	  pop    rcx
	  pop    rax
	  ret
Randomize ENDP

;--------------------------------------------------------------
RandomRange PROC
;
; Returns an unsigned pseudo-random 32-bit integer
; in RAX, between 0 and n-1. Input parameter:
; RAX = n.
;--------------------------------------------------------------
	 push  rbx
	 push  rdx

	 mov   rbx,rax		; maximum value
	 call  Random64		; rax = random number
	 mov   rdx,0
	 div   rbx			; divide by max value
	 mov   rax,rdx		; return the remainder

	 pop   rdx
	 pop   rbx

	 ret
RandomRange ENDP

;--------------------------------------------------------
ReadInt64 PROC USES rcx rdx
;
; Reads a 64-bit signed decimal integer from standard
; input, stopping when the Enter key is pressed.
; All valid digits occurring before a non-numeric character
; are converted to the integer value. Leading spaces are
; ignored, and an optional leading + or - sign is permitted.
; All spaces return a valid integer, value zero.

; Receives: nothing
; Returns:  If OF=0, the integer is valid, and RAX = binary value.
;   If OF=1, the integer is invalid and RAX = 0.
;
;--------------------------------------------------------
MAX_DIGITS = 80
.data
digitBuffer BYTE MAX_DIGITS DUP(?),?
.code
; Input a signed decimal string.

	mov   rdx,OFFSET digitBuffer
	mov   rcx,MAX_DIGITS
	call  ReadString
	mov   rcx,rax				; save length in RCX

; Convert to binary (RDX -> string, RCX = length)
	
	call  ParseInteger64		; returns RAX, Overflow flag indicates status

	ret
ReadInt64 ENDP

;--------------------------------------------------------
ReadString PROC uses rbx rcx rdx rdi r8 r9
	LOCAL bufSize:QWORD, saveFlags:DWORD, junk:DWORD
;
; Reads a string from the keyboard and places the characters
; in a buffer.
; Receives: RDX offset of the input buffer
;           RCX = maximum characters to input (including terminal null)
; Returns:  RAX = size of the input string.
; Comments: Stops when the Enter key is pressed. If the user
; types more characters than (RCX-1), the excess characters
; are ignored.
;--------------------------------------------------------
.data
_$$temp DWORD ?		     
.code
	CheckInit
	
	sub   rsp,(5 * 8)				; set aside shadow stack for 5 parameters 

	mov   rdi,rdx					; set RDI to buffer offset
	mov   bufSize,rcx				; save buffer size

	; Read from the console into the input buffer
	mov   rcx,consoleInHandle
	mov   rdx,rdx					; buffer offset
	mov   r8,bufSize				; corrected 7/2/2015
	lea	  r9,bytesRead
	mov	  qword ptr [rsp + 4 * SIZEOF QWORD], 0			; (reserved parameter, set to zero)
	push  rdx						; corrected 7/2/2015
	call  ReadConsoleA
	pop   rdx						; corrected 7/2/2015

	; Some cleanup is needed. We must remove the trailing Line feed character
	; from the input buffer.
	cmp  bytesRead,0
	jz   L5 		                ; skip move if zero chars input

	dec   bytesRead					; make first adjustment to bytesRead
	cld								; search forward
	mov   rcx,bufSize				; repetition count for SCASB
	mov   al,0Ah					; scan for 0Ah (Line Feed) terminal character
	repne scasb
	jne   L1		                ; if not found, jump to L1

	;if we reach this line, length of input string <= (bufsize - 2)

	dec   bytesRead					; second adjustment to bytesRead
	sub   rdi,2		                ; 0Ah found: back up two positions
	cmp   rdi,rdx 					; don't back up to before the user's buffer
	jae   L2
	mov   rdi,rdx 					; 0Ah must be the only byte in the buffer
	jmp   L2		                ; and jump to L2

L1:	mov   rdi,rdx					; point to last byte in buffer
	add   rdi,bufSize
	dec   rdi
	mov   BYTE PTR [rdi],0    	    ; insert null byte

	; Save the current console mode
	mov   rcx,consoleInHandle
	lea   rdx,saveFlags
	call  GetConsoleMode

	; Switch to single character mode
	mov   rcx,consoleInHandle
	mov   rdx,0
	call  SetConsoleMode

	; Clear excess characters from the buffer, 1 byte at a time
L6:	mov   rcx,consoleInHandle
	lea   rdx,junk
	mov   r8,1
	mov   r9,OFFSET _$$temp
	mov	  qword ptr [rsp + 4 * SIZEOF QWORD], 0		; (reserved parameter)
	call  ReadConsoleA
	
	mov   al,BYTE PTR junk
	cmp   al,0Ah 				; the terminal line feed character
	jne   L6     				; keep looking, it must be there somewhere

	; Restore the saved console mode
	mov   rcx,consoleInHandle
	mov   rdx,0
	mov   edx,saveFlags
	call  SetConsoleMode
	jmp   L5

L2:	mov   BYTE PTR [rdi],0		; insert null byte at end of string
 
L5: mov rax,bytesRead
	add   rsp,(5 * 8)			; restore the stack pointer

	ret
ReadString ENDP

; -----------------------------------------------------
; Str_compare
; Compares two strings
; Receives: RSI points to the source string
;           RDI points to the target string
; Returns:  Sets ZF if the strings are equal
;		    Sets CF if RSI string < RDI string
;------------------------------------------------------
Str_compare proc uses rax rdx rsi rdi
L1: mov  al,[rsi]
    mov  dl,[rdi]
    cmp  al,0    		; end of string1?
    jne  L2      		; no
    cmp  dl,0    		; yes: end of string2?
    jne  L2      		; no
    jmp  L3      		; yes, exit with ZF = 1

L2: inc  rsi      		; point to next
    inc  rdi
    cmp  al,dl   		; chars equal?
    je   L1      		; yes: continue loop
                 		; no: exit with flags set
L3: ret
Str_compare endp

;-------------------------------------------------
; Str_copy
; Copies a string
; Receives: RSI points to the source string
;           RDI points to the target string
; Returns:  nothing
;-------------------------------------------------
Str_copy proc uses rax rcx rsi rdi
 
	mov  rcx,rsi			; get length of source string
	call Str_length

	mov  rcx,rax		    ; repeat count
	inc  rcx         		; add 1 for null byte
	cld               		; direction = up
	rep  movsb      		; copy the string
	ret
Str_copy endp

;---------------------------------------------------------
; Str_length
; Returns the length of a null-terminated string.
; Receives: RCX points to the string
; Returns: RAX = string length
;---------------------------------------------------------
Str_length PROC uses rdi
	mov  rdi,rcx
	mov  rax,0     	             ; character count
L1:
	cmp  BYTE PTR [rdi],0	     ; end of string?
	je   L2	                     ; yes: quit
	inc  rdi	                     ; no: point to next
	inc  rax	                     ; add 1 to count
	jmp  L1
L2: 
	ret
Str_length ENDP

;------------------------------------------------------
; WriteHex64
; Writes an unsigned 64-bit hexadecimal number to
; 		the console window
; Receives: RAX = the number to write
; Returns: nothing
;------------------------------------------------------
WriteHex64 proc
	push rbx
	mov  rbx,8
	call WriteHexB
	pop  rbx
	ret
WriteHex64 ENDP

;--------------------------------------------------
; WriteHex32
; Writes the lower 32 bits of an integer to the
; console window in hexadecimal format.
; Receives: RAX = the number to write.
; Returns: nothing
;--------------------------------------------------
WriteHex32 PROC
	push rbx
	mov  rbx,4		; number of bytes
	call WriteHexB
	pop  rbx
	ret
WriteHex32 ENDP

;--------------------------------------------------
; AsciiDigit
; Converts a byte into an ASCII digit. Used 
; by WriteHex & WriteDec
; Receives: AL contains the byte
; Returns: the digit is in AL
;--------------------------------------------------
AsciiDigit PROC PRIVATE
	 push  rbx
	 mov   rbx,OFFSET xtable
	 xlat
	 pop   rbx
	 ret
AsciiDigit ENDP

;------------------------------------------------------
; WriteHexB
; Writes an unsigned 64-bit hexadecimal number to
; the console window.
; Receives: RAX = the number to write. RBX = display size (1,2,4,8)
; Returns: nothing
;------------------------------------------------------
WriteHexB PROC 
	LOCAL displaySize:QWORD

	DOUBLEWORD_BUFSIZE = 8
QUADWORD_BUFSIZE = 16
.data
bufferLHB BYTE QUADWORD_BUFSIZE DUP(?),0

.code
	push  rbx						; must be preserved
	push  rdi
	mov displaySize,rbx				; save component size

; Clear unused bits from EAX to avoid a divide overflow.
; Also, verify that EBX contains either 1, 2, 4, or 8. If any
; other value is found, default to 8.

A1: cmp  rbx,1					; check the specified display size
	 jne  A2
	 and  rax,0FFh				; mask lower byte, clear remaining bits
	 jmp	 A99

A2: cmp	 rbx,2
	 jne	 A4
	 and  rax,0FFFFh				; mask lower word
	 jmp	 A99

A4: cmp   rbx,4
	 jne   A8
	 mov   r8,0FFFFFFFFh			; clears upper 32 bits??
	 and   rax,r8					; mask lower doubleword
	 mov   displaySize,4
	 jmp   A99

A8: mov displaySize,8			; default size (quadword) == 8
A99:
	CheckInit

	mov   rdi,displaySize	; let EDI point to the end of the buffer:
	shl   rdi,1					; multiply by 2 (2 digits per byte)
	mov   bufferLHB[rdi],0 	; store null string terminator
	dec   rdi					; back up one position

	mov   rcx,0           	; digit counter
	mov   rbx,16				; hexadecimal base (divisor)

L1:
	mov   rdx,0          	; clear upper dividend
	div   rbx            	; divide EAX by the base

	xchg  rax,rdx        	; swap quotient, remainder
	call  AsciiDigit     	; convert AL to ASCII
	mov   bufferLHB[rdi],al       ; save the digit
	dec   rdi             	; back up in buffer
	xchg  rax,rdx        	; swap quotient, remainder

	inc   rcx             	; increment digit count
	or    rax,rax        	; quotient = 0?
	jnz   L1           	; no, divide again

	 ; Insert leading zeros

	mov   rax,displaySize	; set EAX to the
	shl   rax,1					; number of digits to print
	sub   rax,rcx				; subtract the actual digit count
	jz    L3           		; display now if no leading zeros required
	mov   rcx,rax         	; CX = number of leading zeros to insert

L2:
	mov   bufferLHB[rdi],'0'	; insert a zero
	dec   rdi                  	; back up
	loop  L2                	; continue the loop

	; Display the digits. RCX contains the number of
	; digits to display, and RDX points to the first digit.
L3:
	mov   rcx,displaySize		; output format size
	shl   rcx,1         		; multiply by 2
	inc   rdi
	mov   rdx,OFFSET bufferLHB
	
	add   rdx,rdi
	call  WriteString

	pop   rdi
	pop	  rbx				; must be preserved
	ret
WriteHexB ENDP

;-----------------------------------------------------
; WriteInt64
; Writes a 64-bit signed binary integer to the 
; console window in ASCII decimal.
; Receives: RAX = the integer
; Returns:  nothing
; Comments: Displays a leading sign, no leading zeros.
;-----------------------------------------------------
WriteInt64 PROC uses rbx rcx rdi

WI_Bufsize = 21		; size of digit buffer
true  =   1
false =   0
.data
buffer_B  BYTE  WI_Bufsize DUP(0),0  ; buffer to hold digits
neg_flag  BYTE  ?

.code
	mov   neg_flag,false    ; assume neg_flag is false
	or    rax,rax             ; is AX positive?
	jns   WIS1              ; yes: jump to B1
	neg   rax                ; no: make it positive
	mov   neg_flag,true     ; set neg_flag to true

WIS1:
	mov   rcx,0              ; digit count = 0
	mov   rdi,OFFSET buffer_B
	add   rdi,(WI_Bufsize-1)
	mov   rbx,10             ; will divide by 10

WIS2:
	mov   rdx,0              ; set dividend to 0
	div   rbx                ; divide AX by 10
	or    dl,30h            ; convert remainder to ASCII
	dec   rdi                ; reverse through the buffer
	mov   [rdi],dl           ; store ASCII digit
	inc   rcx                ; increment digit count
	or    rax,rax             ; quotient > 0?
	jnz   WIS2              ; yes: divide again

	; Insert a leading sign into the buffer.
	dec   rdi						; back up in the buffer
	inc   rcx               	; increment counter
	mov   BYTE PTR [rdi],'+' 	; insert plus sign
	cmp   neg_flag,false    	; was the number positive?
	jz    WIS3              	; yes
	mov   BYTE PTR [rdi],'-' 	; no: insert negative sign

WIS3:	; Display the number
	mov   rdx,rdi
	call  WriteString

	ret
WriteInt64 ENDP

;--------------------------------------------------------
; WriteString 
; Writes a null-terminated string to the console.
; Modifies: bytesWritten
; Receives: RDX points to the string
; Returns: nothing
;--------------------------------------------------------
WriteString proc uses rcx rdx r8 r9

	sub  rsp, (5 * 8) 					; create shadow space for 5 parameters

	CheckInit							; macro that checks and verifies initialization
	mov	 rcx,rdx
	call Str_length   					; returns length of string in EAX
		
	mov	 rcx,consoleOutHandle
	mov	 rdx,rdx						; string pointer
	mov	 r8, rax						; length of string
	lea	 r9,bytesWritten
	mov	 qword ptr [rsp + 4 * SIZEOF QWORD], 0	; (reserved parameter, set to zero)
	call WriteConsoleA

	add  rsp,(5 * 8)
	ret
WriteString ENDP

end
