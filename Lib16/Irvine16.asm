TITLE  Link Library Functions		(Irvine16.asm)

Comment @

**** TODO *****
TEST ParseDecimal32, ParseInteger32, ReadDec

Add CloseFile, CreateOutputFile, OpenInputFile, ReadFromFile,
WriteToFile, StrLength, 
	

This library was created exlusively for use with the book,
"Assembly Language for Intel-Based Computers, 4th Edition & 5th Edition",
by Kip R. Irvine, 2002 & 2006.

Copyright 2002-2006, Prentice-Hall Incorporated. No part of this file may be
reproduced, in any form or by any other means, without permission in writing
from the publisher.

Updates to this file will be posted on the book's site:
www.asmirvine.com

Recent update history:
	06/28/2005: Added SetTextColor
	7/8/05: Moved mShowRegister to macros.inc
	1/23/2010: Added ParseDecimal32, ParseInteger32, ReadDec

Acknowledgements:
------------------------------
Most of the code in this library was written by Kip Irvine.
Special thanks to Gerald Cahill for his many insights, suggestions, and bug fixes.
Also to Courtney Amor, a student at UCLA, and Ben Schwartz.

Alphabetical Listing of Procedures
----------------------------------
(Unless otherwise marked, all procedures are documented in Chapter 5.)

Clrscr
Crlf
Delay
DumpMem
DumpRegs
GetCommandTail
GetMaxXY
GetMseconds
Gotoxy
IsDigit
ParseDecimal32
ParseInteger32
Random32
Randomize
RandomRange
ReadChar
ReadDec
ReadHex
ReadInt
ReadString
SetTextColor
Str_compare	Chapter 9
Str_copy		Chapter 9
Str_length	Chapter 9
Str_trim		Chapter 9
Str_ucase		Chapter 9
WaitMsg
WriteBin
WriteChar
WriteDec
WriteHex
WriteInt
WriteString
=================================@

INCLUDE Irvine16.inc
INCLUDE Macros.inc

; Write <count< spaces to standard output

WriteSpace MACRO count
Local spaces
.data
spaces BYTE count dup(' '),0
.code
	mov  dx,OFFSET spaces
	call WriteString
ENDM

; Send a newline sequence to standard output

NewLine MACRO
Local temp
.data
temp BYTE 13,10,0
.code
	push dx
	mov  dx,OFFSET temp
	call WriteString
	pop  dx
ENDM

;-------------------------------------
ShowFlag MACRO flagName,shiftCount
	    LOCAL flagStr, flagVal, L1
;
; Display a single flag value
;-------------------------------------

.data
flagStr BYTE "  &flagName="
flagVal BYTE ?,0

.code
	push ax
	push dx

	mov  ax,flags	; retrieve the flags
	mov  flagVal,'1'
	shr  ax,shiftCount	; shift into carry flag
	jc   L1
	mov  flagVal,'0'
L1:
	mov  dx,OFFSET flagStr	; display flag name and value
	call WriteString

	pop  dx
	pop  ax
ENDM

;--------- END OF MACRO DEFINITIONS ---------------------------


;********************* SHARED DATA AREA **********************
.data?
buffer BYTE 512 dup(?)

;*************************************************************

.code
;------------------------------------------------------
Clrscr PROC
;
; Clears the screen (video page 0) and locates the cursor
; at row 0, column 0.
; Receives: nothing
; Returns:  nothing
; Currently affects only 25 rows and 80 columns
;-------------------------------------------------------
	pusha
	mov     ax,0600h    	; scroll window up
	mov     cx,0        	; upper left corner (0,0)
	mov     dx,184Fh    	; lower right corner (24,79)
	mov     bh,7        	; normal attribute
	int     10h         	; call BIOS
	mov     ah,2        	; locate cursor at 0,0
	mov     bh,0        	; video page 0
	mov     dx,0	; row 0, column 0
	int     10h
	popa
	ret
Clrscr ENDP


;-----------------------------------------------------
Crlf PROC
;
; Writes a carriage return / linefeed
; sequence (0Dh,0Ah) to standard output.
;-----------------------------------------------------
	NewLine	; invoke a macro
	ret
Crlf ENDP

;-----------------------------------------------------------
Delay PROC
;
; Create an n-millisecond delay.
; Receives: EAX = milliseconds
; Returns: nothing
; Remarks: May only used under Windows 95, 98, or ME. Does
; not work under Windows NT, 2000, or XP, because it
; directly accesses hardware ports.
; Source: "The 80x86 IBM PC & Compatible Computers" by
; Mazidi and Mazidi, page 343. Prentice-Hall, 1995.
;-----------------------------------------------------------

MsToMicro = 1000000	; convert ms to microseconds
ClockFrequency = 15085	; microseconds per tick
.code
	pushad
; Convert milliseconds to microseconds.
	mov  ebx,MsToMicro
	mul  ebx

; Divide by clock frequency of 15.085 microseconds,
; producing the counter for port 61h.
	mov  ebx,ClockFrequency
	div  ebx	; eax = counter
	mov  ecx,eax

; Begin checking port 61h, watching bit 4 toggle
; between 1 and 0 every 15.085 microseconds.
L1:
	in  al,61h	; read port 61h
	and al,10h	; clear all bits except bit 4
	cmp al,ah	; has it changed?
	je  L1	; no: try again
	mov ah,al	; yes: save status
	dec ecx
	cmp ecx,0	; loop finished yet?
	ja  L1

quit:
	popad
	ret
Delay ENDP


;---------------------------------------------------
DumpMem PROC
	   LOCAL unitsize:word, byteCount:word
;
; Writes a range of memory to standard output
; in hexadecimal.
; Receives: SI = starting OFFSET, CX = number of units,
;           BX = unit size (1=byte, 2=word, or 4=doubleword)
; Returns:  nothing
;---------------------------------------------------
.data
oneSpace   BYTE ' ',0
dumpPrompt BYTE 13,10,"Dump of offset ",0
.code
	pushad

	mov  dx,OFFSET dumpPrompt
	call WriteString
	movzx eax,si
	call  WriteHex
	NewLine

	mov  byteCount,0
	mov  unitsize,bx
	cmp  bx,4	; select output size
	je   L1
	cmp  bx,2
	je   L2
	jmp  L3

L1:	; doubleword output
	mov  eax,[si]
	call WriteHex
	WriteSpace 2
	add  si,bx
	Loop L1
	jmp  L4

L2:	; word output
	mov  ax,[si]	; get a word from memory
	ror  ax,8	; display high byte
	call HexByte
	ror  ax,8	; display low byte
	call HexByte
	WriteSpace 1	; display 1 space
	add  si,unitsize	; point to next word
	Loop L2
	jmp  L4

; Byte output: 16 bytes per line

L3:
	mov  al,[si]
	call HexByte
	inc  byteCount
	WriteSpace 1
	inc  si

	; if( byteCount mod 16 == 0 ) call Crlf

	mov  dx,0
	mov  ax,byteCount
	mov  bx,16
	div  bx
	cmp  dx,0
	jne  L3B
	NewLine
L3B:
	Loop L3
	jmp  L4

L4:
	NewLine
	popad
	ret
DumpMem ENDP


;--------------------------------------------------
GetCommandTail PROC
;
; Gets a copy of the DOS command tail at PSP:80h.
; Receives: DX contains the offset of the buffer
; that receives a copy of the command tail.
; Returns: CF=1 if the buffer is empty; otherwise,
; CF=0.
; Last update: 7/8/05
;--------------------------------------------------
SPACE = 20h
    push es
	pusha		; save general registers

	mov	ah,62h	; get PSP segment address
	int	21h	; returned in BX
	mov	es,bx	; copied to ES

	mov	si,dx	; point to buffer
	mov	di,81h	; PSP offset of command tail
	mov	cx,0	; byte count
	mov	cl,es:[di-1]	; get length byte
	cmp	cx,0	; is the tail empty?
	je	L2	; yes: exit
	cld		; scan in forward direction
	mov	al,SPACE	; space character
	repz	scasb	; scan for non space
	jz	L2	; all spaces found
	dec	di	; non space found
	inc	cx

L1: mov	al,es:[di]	; copy tail to buffer
	mov	[si],al	; pointed to by DS:SI
	inc	si
	inc	di
	loop	L1
	clc		; CF=0 means tail found
	jmp	L3

L2:	stc		; set carry: no command tail
L3:	mov	byte ptr [si],0	; store null byte
	popa		; restore registers
	pop	es
	ret
GetCommandTail ENDP


;----------------------------------------------------------------
GetMaxXY PROC

; Returns the current columns (X) and rows (Y) of the console
; window buffer. These values can change while a program is running
; if the user modifies the properties of the application window.
; Receives: nothing
; Returns: DH = rows (Y); DL = columns (X)
; (range of each is 1-255)
;
; Added to the library on 10/20/2002, on the suggestion of Ben Schwartz.
;----------------------------------------------------------------
.data
videoInfo VideoInfoStruc <>
str1 BYTE "Video function 1Bh is not supported",0dh,0ah,0
.code
	push ax
	push bx
	push cx

	mov  ah,1Bh	; get video information
	mov  bx,0	; always zero
	push ds
	pop  es
	mov  di,OFFSET videoInfo
	int  10h
	cmp  al,1Bh
	jne  notSupported

	mov  dh,videoInfo.numCharRows
	mov  dl,BYTE PTR videoInfo.numCharColumns

	jmp  finished

notSupported:
	mov dx,OFFSET str1
	call WriteString

finished:
	pop cx
	pop bx
	pop ax
	ret
GetMaxXY ENDP


;-------------------------------------------------------
GetMseconds PROC
	LOCAL hours:BYTE, minutes:BYTE, seconds:BYTE, hhss:BYTE
;
; Returns the number of milliseconds that have elapsed
; since midnight of the current day.
; Receives: nothing
; Returns: EAX = milliseconds, accurate to 50 milliseconds
;--------------------------------------------------------
.data

timerec TimeRecord <>
mSec  DWORD  ?

.code
	push ebx
	push ecx
	push edx

; get system time (see Section 13.2.4)
	mov  ah,2Ch
	int  21h
	mov  hours,ch
	mov  minutes,cl
	mov  seconds,dh
	mov  hhss,dl

; (mSec = hours * 3600000)
	movzx eax,hours
	mov  ebx,3600000
	mul  ebx
	mov  mSec,eax

; mSec = mSec + (minutes * 60000)
	movzx  eax,minutes
	mov  ebx,60000
	mul  ebx
	add  mSec,eax

; mSec = mSec + (seconds * 1000)
	movzx eax,seconds
	mov  ebx,1000
	mul  ebx
	add  mSec,eax

; mSec = mSec + (hundredths * 10)
	movzx eax,hhss
	mov  ebx,10
	mul  ebx
	add  mSec,eax

; Return mSec in EAX
	mov  eax,mSec

	pop  edx
	pop  ecx
	pop  ebx
	ret
GetMseconds ENDP


;---------------------------------------------------
Gotoxy PROC
;
; Sets the cursor position on video page 0.
; Receives: DH,DL = row, column
; Returns: nothing
;---------------------------------------------------
	pusha
	mov ah,2
	mov bh,0
	int 10h
	popa
	ret
Gotoxy ENDP


;---------------------------------------------------
HexByte PROC
	LOCAL theByte:BYTE
;
; Display the byte in AL in hexadecimal
; Called only by DumpMem. Updated 9/21/01
;---------------------------------------------------
	pusha
	mov  theByte,al	; save the byte
	mov  cx,2

HB1:
	rol  theByte,4
	mov  al,theByte
	and  al,0Fh
	mov  bx,OFFSET xtable
	xlat

	; insert hex char in the buffer
	; and display using WriteString
	mov  buffer,al
	mov  [buffer+1],0
	mov  dx,OFFSET buffer
	call WriteString

	Loop HB1

	popa
	ret
HexByte ENDP

;---------------------------------------------------
DumpRegs PROC
;
; Displays EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP in
; hexadecimal. Also displays the Zero, Sign, Carry, and
; Overflow flags.
; Receives: nothing.
; Returns: nothing.
;
; Warning: do not create any local variables or stack
; parameters, because they will alter the EBP register.
;---------------------------------------------------
.data
flags  WORD  ?
saveIP WORD ?
saveSP WORD ?
.code
	pop saveIP	; get current IP
	mov saveSP,sp	; save SP's value at entry
	push saveIP	; replace it on stack
	push eax
	pushfd	; push flags

	pushf	; copy flags to a variable
	pop  flags

	NewLine
	mShowRegister EAX,EAX
	mShowRegister EBX,EBX
	mShowRegister ECX,ECX
	mShowRegister EDX,EDX
	NewLine
	mShowRegister ESI,ESI
	mShowRegister EDI,EDI

	mShowRegister EBP,EBP

	movzx eax,saveSP
	mShowRegister ESP,EAX
	NewLine

	movzx eax,saveIP
	mShowRegister EIP,EAX

	movzx eax,flags
	mShowRegister EFL,EAX

; Show the flags
	ShowFlag CF,1
	ShowFlag SF,8
	ShowFlag ZF,7
	ShowFlag OF,12

	NewLine
	NewLine

	popfd	; restore flags
	pop eax	; restore EAX
	ret
DumpRegs ENDP


;-----------------------------------------------
Isdigit PROC
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
Isdigit ENDP

;--------------------------------------------------------
ParseDecimal32 PROC USES ebx ecx edx esi
  LOCAL saveDigit:DWORD
;
; Converts (parses) a string containing an unsigned decimal
; integer, and converts it to binary. All valid digits occurring 
; before a non-numeric character are converted. 
; Leading spaces are ignored.

; Receives: EDX = offset of string, ECX = length 
; Returns:
;  If the integer is blank, EAX=0 and CF=1
;  If the integer contains only spaces, EAX=0 and CF=1
;  If the integer is larger than 2^32-1, EAX=0 and CF=1
;  Otherwise, EAX=converted integer, and CF=0
;
; NOT TESTED FOR IRVINE16 YET
;--------------------------------------------------------

	mov   esi,edx           		; save offset in ESI

	cmp   ecx,0            		; length greater than zero?
	jne   L1              		; yes: continue
	mov   eax,0            		; no: set return value
	jmp   L5              		; and exit with CF=1

; Skip over leading spaces, tabs

L1:	mov   al,[esi]         		; get a character from buffer
	cmp   al,' '        		; space character found?
	je	L1A		; yes: skip it
	cmp	al,TAB		; TAB found?
	je	L1A		; yes: skip it
	jmp   L2              		; no: goto next step
	
L1A:
	inc   esi              		; yes: point to next char
	loop  L1		; continue searching until end of string
	jmp   L5		; exit with CF=1 if all spaces

; Replaced code (7/19/05)---------------------------------------------
;L1:mov   al,[esi]         		; get a character from buffer
;	cmp   al,' '          		; space character found?
;	jne   L2              		; no: goto next step
;	inc   esi              		; yes: point to next char
;	loop  L1		; all spaces?
;	jmp   L5		; yes: exit with CF=1
;---------------------------------------------------------------------

; Start to convert the number.

L2:	mov  eax,0           		; clear accumulator
	mov  ebx,10          		; EBX is the divisor

; Repeat loop for each digit.

L3:	mov  dl,[esi]		; get character from buffer
	cmp  dl,'0'		; character < '0'?
	jb   L4
	cmp  dl,'9'		; character > '9'?
	ja   L4
	and  edx,0Fh		; no: convert to binary

	mov  saveDigit,edx
	mul  ebx		; EDX:EAX = EAX * EBX
	jc   L5		; quit if Carry (EDX > 0)
	mov  edx,saveDigit
	add  eax,edx         		; add new digit to sum
	jc   L5		; quit if Carry generated
	inc  esi              		; point to next digit
	jmp  L3		; get next digit

L4:	clc			; succesful completion (CF=0)
	jmp  L6

L5:	mov  eax,0		; clear result to zero
	stc			; signal an error (CF=1)

L6:	ret
ParseDecimal32 ENDP

;--------------------------------------------------------
ParseInteger32 PROC USES ebx ecx edx esi
  LOCAL Lsign:SDWORD, saveDigit:DWORD
;
; Converts a string containing a signed decimal integer to
; binary. 
;
; All valid digits occurring before a non-numeric character
; are converted. Leading spaces are ignored, and an optional 
; leading + or - sign is permitted. If the string is blank, 
; a value of zero is returned.
;
; Receives: EDX = string offset, ECX = string length
; Returns:  If OF=0, the integer is valid, and EAX = binary value.
;   If OF=1, the integer is invalid and EAX = 0.
;
; NOT TESTED FOR IRVINE16 YET
;--------------------------------------------------------
.data
overflow_msgL BYTE  " <32-bit integer overflow>",0
invalid_msgL  BYTE  " <invalid integer>",0
.code

	mov   Lsign,1                   ; assume number is positive
	mov   esi,edx                   ; save offset in SI

	cmp   ecx,0                     ; length greater than zero?
	jne   L1                        ; yes: continue
	mov   eax,0                     ; no: set return value
	jmp   L10                       ; and exit

; Skip over leading spaces and tabs.

L1:	mov   al,[esi]         		; get a character from buffer
	cmp   al,' '        		; space character found?
	je	L1A		; yes: skip it
	cmp	al,TAB		; TAB found?
	je	L1A		; yes: skip it
	jmp   L2              		; no: goto next step
	
L1A:
	inc   esi              		; yes: point to next char
	loop  L1		; continue searching until end of string
	mov	eax,0		; all spaces?
	jmp   L10		; return 0 as a valid value

;-- Replaced code (7/19/05)---------------------------------------
;L1:	mov   al,[esi]                  ; get a character from buffer
;	cmp   al,' '                    ; space character found?
;	jne   L2                        ; no: check for a sign
;	inc   esi                       ; yes: point to next char
;	loop  L1
;	mov   eax,0	  ; all spaces?
;	jmp   L10	  ; return zero as valid value
;------------------------------------------------------------------

; Check for a leading sign.

L2:	cmp   al,'-'                    ; minus sign found?
	jne   L3                        ; no: look for plus sign

	mov   Lsign,-1                  ; yes: sign is negative
	dec   ecx                       ; subtract from counter
	inc   esi                       ; point to next char
	jmp   L3A

L3:	cmp   al,'+'                    ; plus sign found?
	jne   L3A               			; no: skip
	inc   esi                       ; yes: move past the sign
	dec   ecx                       ; subtract from digit counter

; Test the first digit, and exit if nonnumeric.

L3A: mov  al,[esi]          	; get first character
	call IsDigit            	; is it a digit?
	jnz  L7A                	; no: show error message

; Start to convert the number.

L4:	mov   eax,0                  	; clear accumulator
	mov   ebx,10                  ; EBX is the divisor

; Repeat loop for each digit.

L5:	mov  dl,[esi]           	; get character from buffer
	cmp  dl,'0'             	; character < '0'?
	jb   L9
	cmp  dl,'9'             	; character > '9'?
	ja   L9
	and  edx,0Fh            	; no: convert to binary

	mov  saveDigit,edx
	imul ebx               	; EDX:EAX = EAX * EBX
	mov  edx,saveDigit

	jo   L6                	; quit if overflow
	add  eax,edx            	; add new digit to AX
	jo   L6                 	; quit if overflow
	inc  esi                	; point to next digit
	jmp  L5                 	; get next digit

; Overflow has occured, unlesss EAX = 80000000h
; and the sign is negative:

L6:	cmp  eax,80000000h
	jne  L7
	cmp  Lsign,-1
    jne  L7                 	; overflow occurred
    jmp  L9                 	; the integer is valid

; Choose "integer overflow" messsage.

L7: mov  edx,OFFSET overflow_msgL
    jmp  L8

; Choose "invalid integer" message.

L7A:
    mov  edx,OFFSET invalid_msgL

; Display the error message pointed to by EDX, and set the Overflow flag.

L8:	call WriteString
    call Crlf
    mov al,127
    add al,1                	; set Overflow flag
    mov  eax,0              	; set return value to zero
    jmp  L10                	; and exit

; IMUL leaves the Sign flag in an undeterminate state, so the OR instruction
; determines the sign of the iteger in EAX.
L9:	imul Lsign                  	; EAX = EAX * sign
    or eax,eax              	; determine the number's Sign

L10:ret
ParseInteger32 ENDP

;--------------------------------------------------------------
RandomRange PROC
;
; Returns an unsigned pseudo-random 32-bit integer
; in EAX, between 0 and n-1. Input parameter:
; EAX = n.
;--------------------------------------------------------------
	push  bp
	mov   bp,sp
	push  ebx
	push  edx

	mov   ebx,eax  ; maximum value
	call  Random32 ; eax = random number
	mov   edx,0
	div   ebx      ; divide by max value
	mov   eax,edx  ; return the remainder

	pop   edx
	pop   ebx
	pop   bp
	ret
RandomRange ENDP


;--------------------------------------------------------------
Random32  PROC
;
; Returns an unsigned pseudo-random 32-bit integer
; in EAX,in the range 0 - FFFFFFFFh.
;--------------------------------------------------------------
.data
seed  dd 1
.code
	push  edx
	mov   eax, 343FDh
	imul  seed
	add   eax, 269EC3h
	mov   seed, eax    ; save the seed for the next call
	ror   eax,8        ; rotate out the lowest digit (10/22/00)
	pop   edx
	ret
Random32  ENDP


;--------------------------------------------------------
Randomize PROC
;
; Re-seeds the random number generator with the current time
; in milliseconds.
; Last update: 10/21/2002
;--------------------------------------------------------
	push eax
	call GetMseconds
	mov  seed,eax
	pop  eax
	ret
Randomize ENDP


;---------------------------------------------------------
ReadChar PROC
;
; Reads one character from standard input. The character is
; not echoed on the screen. Waits for the character if none is
; currently in the input buffer.
; Receives: nothing
; Returns:  AL = ASCII code
;----------------------------------------------------------
	mov  ah,1
	int  21h
	ret
ReadChar ENDP

;--------------------------------------------------------
ReadDec PROC USES ecx edx
;
; Reads a 32-bit unsigned decimal integer from the keyboard,
; stopping when the Enter key is pressed.All valid digits occurring 
; before a non-numeric character are converted to the integer value. 
; Leading spaces are ignored.

; Receives: nothing
; Returns:
;  If the integer is blank, EAX=0 and CF=1
;  If the integer contains only spaces, EAX=0 and CF=1
;  If the integer is larger than 2^32-1, EAX=0 and CF=1
;  Otherwise, EAX=converted integer, and CF=0
;
; NOT TESTED FOR IRVINE16 YET
;--------------------------------------------------------

	mov   edx,OFFSET digitBuffer
	mov	ecx,MAX_DIGITS
	call  ReadString
	mov	ecx,eax	; save length

	call	ParseDecimal32	; returns EAX

	ret
ReadDec ENDP

;--------------------------------------------------------
ReadHex PROC
;
; Reads a 32-bit hexadecimal integer from standard input,
; stopping when the Enter key is pressed.
; Receives: nothing
; Returns: EAX = binary integer value
; Remarks: No error checking performed for bad digits
; or excess digits.
; Last update: 11/7/01
;--------------------------------------------------------
.data
HMAX_DIGITS = 20
Hinputarea  BYTE  HMAX_DIGITS dup(0),0
xbtable     BYTE 0,1,2,3,4,5,6,7,8,9,7 DUP(0FFh),10,11,12,13,14,15
numVal      DWORD ?
charVal     BYTE ?

.code
	push ebx
	push ecx
	push edx
	push esi

	mov   edx,OFFSET Hinputarea
	mov   esi,edx		; save in ESI also
	mov   ecx,HMAX_DIGITS
	call  ReadString		; input the string
	mov   ecx,eax           		; save length in ECX

	; Start to convert the number.

B4: mov   numVal,0		; clear accumulator
	mov   ebx,OFFSET xbtable		; translate table

	; Repeat loop for each digit.

B5: mov al,[esi]	; get character from buffer
	cmp al,'F'	; lowercase letter?
	jbe B6	; no
	and al,11011111b	; yes: convert to uppercase

B6:
	sub   al,30h	; adjust for table
	xlat  	; translate to binary
	mov   charVal,al

	mov   eax,16	; numVal *= 16
	mul   numVal
	mov   numVal,eax
	movzx eax,charVal	; numVal += charVal
	add   numVal,eax
	inc   esi	; point to next digit
	loop  B5	; repeat, decrement counter

	mov  eax,numVal	; return binary result
	pop  esi
	pop  edx
	pop  ecx
	pop  ebx
	ret
ReadHex ENDP


;--------------------------------------------------------
ReadInt PROC uses ebx ecx edx esi
  LOCAL Lsign:DWORD, saveDigit:DWORD
;
; Reads a 32-bit signed decimal integer from standard
; input, stopping when the Enter key is pressed.
; All valid digits occurring before a non-numeric character
; are converted to the integer value. Leading spaces are
; ignored, and an optional leading + or - sign is permitted.

; Receives: nothing
; Returns:  If OF=0, the integer is valid, and EAX = binary value.
; If OF=1, the integer is invalid and EAX = 0.
;
; Credits: Thanks to Courtney Amor, a student at the UCLA Mathematics
; department, for pointing out improvements that have been
; implemented in this version.
; Last update: 10/20/2002
;--------------------------------------------------------
.data
LMAX_DIGITS = 80
Linputarea    BYTE  LMAX_DIGITS dup(0),0
overflow_msgL BYTE  0dh,0ah,"<32-bit integer overflow>",0
invalid_msgL  BYTE  "0dh,0ah,<invalid integer>",0
.code

; Input a string of digits using ReadString.

	mov   edx,offset Linputarea
	mov   esi,edx           		; save offset in ESI
	mov   ecx,LMAX_DIGITS
	call  ReadString
	mov   ecx,eax           		; save length in CX
	mov   Lsign,1         		; assume number is positive
	cmp   ecx,0            		; greater than zero?
	jne   L1              		; yes: continue
	mov   eax,0            		; no: set return value
	jmp   L10              		; and exit

; Skip over any leading spaces.

L1:	mov   al,[esi]         		; get a character from buffer
	cmp   al,' '          		; space character found?
	jne   L2              		; no: check for a sign
	inc   esi              		; yes: point to next char
	loop  L1
	jcxz  L8              		; quit if all spaces

; Check for a leading sign.

L2:	cmp   al,'-'          		; minus sign found?
	jne   L3              		; no: look for plus sign

	mov   Lsign,-1        		; yes: sign is negative
	dec   ecx              		; subtract from counter
	inc   esi              		; point to next char
	jmp   L4

L3:	cmp   al,'+'          		; plus sign found?
	jne   L4              		; no: must be a digit
	inc   esi              		; yes: skip over the sign
	dec   ecx              		; subtract from counter

; Test the first digit, and exit if it is nonnumeric.

L3A:mov  al,[esi]		; get first character
	call IsDigit		; is it a digit?
	jnz  L7A		; no: show error message

; Start to convert the number.

L4:	mov   eax,0           		; clear accumulator
	mov   ebx,10          		; EBX is the divisor

; Repeat loop for each digit.

L5:	mov  dl,[esi]		; get character from buffer
	cmp  dl,'0'		; character < '0'?
	jb   L9
	cmp  dl,'9'		; character > '9'?
	ja   L9
	and  edx,0Fh		; no: convert to binary

	mov  saveDigit,edx
	imul ebx		; EDX:EAX = EAX * EBX
	mov  edx,saveDigit

	jo   L6		; quit if overflow
	add  eax,edx         		; add new digit to AX
	jo   L6		; quit if overflow
	inc  esi              		; point to next digit
	jmp  L5		; get next digit

; Overflow has occured, unlesss EAX = 80000000h
; and the sign is negative:

L6: cmp  eax,80000000h
	jne  L7
	cmp  Lsign,-1
	jne  L7		; overflow occurred
	jmp  L9		; the integer is valid

; Choose "integer overflow" messsage.

L7:	mov  edx,OFFSET overflow_msgL
	jmp  L8

; Choose "invalid integer" message.

L7A:
	mov  edx,OFFSET invalid_msgL

; Display the error message pointed to by EDX and set the Overflow flag

L8:	call WriteString
	call Crlf
	mov  al,127
	add  al,1		; set Overflow flag
	mov  eax,0            		; set return value to zero
	jmp  L10		; and exit

; IMUL leaves the Sign flag in an undeterminate state, so the OR instruction
; determines the sign of the iteger in EAX.
L9: imul Lsign           		; EAX = EAX * sign
	or   eax,eax		; determine the number's sign

L10:ret
ReadInt ENDP


;--------------------------------------------------------
ReadString PROC
; Reads a string from standard input and places the
; characters in a buffer. Reads past end of line,
; and removes the CF/LF from the string.
; Receives: DS:DX points to the input buffer,
;           CX = maximum input chars, plus 1.
; Returns:  AX = size of the input string.
; Comments: Stops either when Enter (0Dh) is pressed,
; or (CX-1) characters have been read.
; Bug fixed 9/22/03: return value was too large by 1
;--------------------------------------------------------
	push cx		; save registers
	push si
	push cx		; save digit count again
	mov  si,dx		; point to input buffer
	dec  cx		; save room for null byte

L1:	mov  ah,1		; function: keyboard input
	int  21h		; DOS returns char in AL
	cmp  al,0Dh		; end of line?
	je   L2		; yes: exit
	mov  [si],al		; no: store the character
	inc  si		; increment buffer pointer
	loop L1		; loop until CX=0

L2:	mov  byte ptr [si],0		; end with a null byte
	pop  ax		; original digit count
	sub  ax,cx		; AX = size of input string
	dec  ax		; ADDED 9/22/03	
	pop  si		; restore registers
	pop  cx
	ret
ReadString ENDP


;------------------------------------------------------
SetTextColor PROC
		LOCAL attrib:BYTE
;
; Clears the screen (console window, video page 0) and locates 
; the cursor at row 0, column 0 with a selected color attribute.
; Receives: AX = color attribute (only AL is used, but we 
;   list AX here to be compatible with the Irvine32 library)
; Returns:  nothing
; Checks the current window size, but because of MS-DOS 
; Limitations: rows can be 1-24, 41, or 49. Columns can be 1-79,
; 1-25, 42, or 50. Console windows differing from these ranges 
; will be resized when the window is cleared..
;-------------------------------------------------------
	pusha
	
	mov	attrib,AL	; save the attribute
	mov	ax,0600h    	; scroll window up
	mov	cx,0        	; upper left corner (0,0)
	call	GetMaxXY	; get window dimensions
	sub	dx,0101h
	mov	bh,attrib        	; set attribute
	int	10h         	; call BIOS
	mov	ah,2        	; locate cursor at 0,0
	mov	bh,0        	; video page 0
	mov	dx,0	; row 0, column 0
	int	10h
	popa
	ret
SetTextColor ENDP


;----------------------------------------------------------
Str_compare PROC USES ax dx si di,
	string1:PTR BYTE,
	string2:PTR BYTE
;
; Compare two strings.
; Returns nothing, but the Zero and Carry flags are affected
; exactly as they would be by the CMP instruction.
; Last update: 1/18/02
;-----------------------------------------------------
    mov  si,string1
    mov  di,string2

L1: mov  al,[si]
    mov  dl,[di]
    cmp  al,0    			; end of string1?
    jne  L2      			; no
    cmp  dl,0    			; yes: end of string2?
    jne  L2      			; no
    jmp  L3      			; yes, exit with ZF = 1

L2: inc  si      			; point to next
    inc  di
    cmp  al,dl   			; chars equal?
    je   L1      			; yes: continue loop
                 			; no: exit with flags set
L3: ret
Str_compare ENDP


;---------------------------------------------------------
Str_copy PROC USES ax cx si di,
 	source:PTR BYTE, 		; source string
 	target:PTR BYTE		; target string
;
; Copy a string from source to target.
; Requires: the target string must contain enough
;           space to hold a copy of the source string.
; Last update: 1/18/02
;----------------------------------------------------------
	INVOKE Str_length,source 		; AX = length source
	mov cx,ax		; REP count
	inc cx         		; add 1 for null byte
	mov si,source
	mov di,target
	cld               		; direction = up
	rep movsb      		; copy the string
	ret
Str_copy ENDP


;---------------------------------------------------------
Str_length PROC USES di,
	pString:PTR BYTE	; pointer to string
;
; Return the length of a null-terminated string.
; Receives: pString - pointer to a string
; Returns: AX = string length
; Last update: 1/18/02
;---------------------------------------------------------
	mov di,pString
	mov ax,0     	; character count
L1:
	cmp byte ptr [di],0	; end of string?
	je  L2	; yes: quit
	inc di	; no: point to next
	inc ax	; add 1 to count
	jmp L1
L2: ret
Str_length ENDP


;-----------------------------------------------------------
Str_trim PROC USES ax cx di,
	pString:PTR BYTE,		; points to string
	char:BYTE		; char to remove
;
; Remove all occurences of a given character from
; the end of a string.
; Returns: nothing
; Last update: 1/18/02
;-----------------------------------------------------------
	mov  di,pString
	INVOKE Str_length,di		; returns length in AX
	cmp  ax,0		; zero-length string?
	je   L2		; yes: exit
	mov  cx,ax		; no: counter = string length
	dec  ax
	add  di,ax		; DI points to last char
	mov  al,char		; char to trim
	std		; direction = reverse
	repe scasb		; skip past trim character
	jne  L1		; removed first character?
	dec  di		; adjust DI: ZF=1 && ECX=0
L1:	mov  BYTE PTR [di+2],0		; insert null byte
L2:	ret
Str_trim ENDP


;---------------------------------------------------
Str_ucase PROC USES ax si,
	pString:PTR BYTE
; Convert a null-terminated string to upper case.
; Receives: pString - a pointer to the string
; Returns: nothing
; Last update: 1/18/02
;---------------------------------------------------
	mov si,pString
L1:
	mov al,[si]		; get char
	cmp al,0		; end of string?
	je  L3		; yes: quit
	cmp al,'a'		; below "a"?
	jb  L2
	cmp al,'z'		; above "z"?
	ja  L2
	and BYTE PTR [si],11011111b		; convert the char

L2:	inc si		; next char
	jmp L1

L3: ret
Str_ucase ENDP


;------------------------------------------------------
WaitMsg PROC
;
; Displays "Press any key to continue"
; Receives: nothing
; Returns: nothing
;------------------------------------------------------
.data
waitmsgstr BYTE "Press any key to continue...",0
.code
	push dx
	mov  dx,OFFSET waitmsgstr
	call WriteString
	call ReadChar
	NewLine
	pop  dx
	ret
WaitMsg ENDP


;------------------------------------------------------
WriteBin PROC
;
; Writes a 32-bit integer to standard output in
; binary format. Converted to a shell that calls the
; WriteBinB procedure, to be compatible with the
; library documentation in Chapter 5.
; Receives: EAX = the integer to write
; Returns: nothing
;
; Last update: 11/18/02
;------------------------------------------------------

	push ebx
	mov  ebx,4	; select doubleword format
	call WriteBinB
	pop  ebx

	ret
WriteBin ENDP


;------------------------------------------------------
WriteBinB PROC
;
; Writes a 32-bit integer to standard output in
; binary format.
; Receives: EAX = the integer to write
;           EBX = display size (1,2,4)
; Returns: nothing
;
; Last update: 11/18/02  (added)
;------------------------------------------------------
	pushad

    cmp   ebx,1   	; ensure EBX is 1, 2, or 4
    jz    WB0
    cmp   ebx,2
    jz    WB0
    mov   ebx,4   	; set to 4 (default) even if it was 4
WB0:
    mov   ecx,ebx
    shl   ecx,1   	; number of 4-bit groups in low end of EAX
    cmp   ebx,4
    jz    WB0A
    ror   eax,8   	; assume TYPE==1 and ROR byte
    cmp   ebx,1
    jz    WB0A    	; good assumption
    ror   eax,8   	; TYPE==2 so ROR another byte
WB0A:

	mov   esi,OFFSET buffer

WB1:
	push  ecx	; save loop count

	mov   ecx,4	; 4 bits in each group
WB1A:
	shl   eax,1	; shift EAX left into Carry flag
	mov   BYTE PTR [esi],'0'	; choose '0' as default digit
	jnc   WB2	; if no carry, then jump to L2
	mov   BYTE PTR [esi],'1'	; else move '1' to DL
WB2:
	inc   esi
	Loop  WB1A	; go to next bit within group

	mov   BYTE PTR [esi],' '  	; insert a blank space
	inc   esi	; between groups
	pop   ecx	; restore outer loop count
	loop  WB1	; begin next 4-bit group

    dec  esi    	; eliminate the trailing space
	mov  BYTE PTR [esi],0	; insert null byte at end
    mov  edx,OFFSET buffer	; display the buffer
	call WriteString

	popad
	ret
WriteBinB ENDP


;------------------------------------------------------
WriteChar PROC
;
; Write a character to standard output
; Recevies: AL = character
;------------------------------------------------------
	push ax
	push dx
	mov  ah,2
	mov  dl,al
	int  21h
	pop  dx
	pop  ax
	ret
WriteChar ENDP


;-----------------------------------------------------
WriteDec PROC
;
; Writes an unsigned 32-bit decimal number to
; standard output. Input parameters: EAX = the
; number to write.
;
;------------------------------------------------------
.data
; There will be as many as 10 digits.
BUFFER_SIZE = 12

bufferL BYTE BUFFER_SIZE dup(?),0
xtable BYTE "0123456789ABCDEF"

.code
	pushad               ; save all 32-bit data registers
	mov   cx,0           ; digit counter
	mov   di,OFFSET bufferL
	add   di,(BUFFER_SIZE - 1)
	mov   ebx,10	; decimal number base

WI1:
	mov   edx,0          ; clear dividend to zero
	div   ebx            ; divide EAX by the radix

	xchg  eax,edx        ; swap quotient, remainder
	call  AsciiDigit     ; convert AL to ASCII
	mov   [di],al        ; save the digit
	dec   di             ; back up in buffer
	xchg  eax,edx        ; swap quotient, remainder

	inc   cx             ; increment digit count
	or    eax,eax        ; quotient = 0?
	jnz   WI1            ; no, divide again

	; Display the digits (CX = count)
WI3:
	inc   di
	mov   dx,di
	call  WriteString

WI4:
	popad	; restore 32-bit registers
	ret
WriteDec ENDP

; Convert AL to an ASCII digit.

AsciiDigit PROC private
	push  bx
	mov   bx,OFFSET xtable
	xlat
	pop   bx
	ret
AsciiDigit ENDP


;------------------------------------------------------
WriteHex PROC
;
; Writes an unsigned 32-bit hexadecimal number to
; standard output.
; Input parameters: EAX = the number to write.
; Shell interface for WriteHexB, to retain compatibility
; with the documentation in Chapter 5.
;
; Last update: 11/18/02
;------------------------------------------------------
	push ebx
	mov  ebx,4
	call WriteHexB
	pop  ebx
	ret
WriteHex ENDP


;------------------------------------------------------
WriteHexB PROC
	LOCAL displaySize:DWORD
;
; Writes an unsigned 32-bit hexadecimal number to
; standard output.
; Receives: EAX = the number to write. EBX = display size (1,2,4)
; Returns: nothing
;
; Last update: 11/18/02
;------------------------------------------------------

DOUBLEWORD_BUFSIZE = 8

.data
bufferLHB BYTE DOUBLEWORD_BUFSIZE DUP(?),0

.code
	pushad               	; save all 32-bit data registers
	mov displaySize,ebx	; save component size

; Clear unused bits from EAX to avoid a divide overflow.
; Also, verify that EBX contains either 1, 2, or 4. If any
; other value is found, default to 4.

.IF EBX == 1	; check specified display size
	and  eax,0FFh	; byte == 1
.ELSE
	.IF EBX == 2
	  and  eax,0FFFFh	; word == 2
	.ELSE
	  mov displaySize,4	; default (doubleword) == 4
	.ENDIF
.ENDIF

	mov   edi,displaySize	; let EDI point to the end of the buffer:
	shl   edi,1	; multiply by 2 (2 digits per byte)
	mov   bufferLHB[edi],0 	; store null string terminator
	dec   edi	; back up one position

	mov   ecx,0           	; digit counter
	mov   ebx,16	; hexadecimal base (divisor)

L1:
	mov   edx,0          	; clear upper dividend
	div   ebx            	; divide EAX by the base

	xchg  eax,edx        	; swap quotient, remainder
	call  AsciiDigit     	; convert AL to ASCII
	mov   bufferLHB[edi],al       ; save the digit
	dec   edi             	; back up in buffer
	xchg  eax,edx        	; swap quotient, remainder

	inc   ecx             	; increment digit count
	or    eax,eax        	; quotient = 0?
	jnz   L1           	; no, divide again

	 ; Insert leading zeros

	mov   eax,displaySize	; set EAX to the
	shl   eax,1	; number of digits to print
	sub   eax,ecx	; subtract the actual digit count
	jz    L3           	; display now if no leading zeros required
	mov   ecx,eax         	; CX = number of leading zeros to insert

L2:
	mov   bufferLHB[edi],'0'	; insert a zero
	dec   edi                  	; back up
	loop  L2                	; continue the loop

	; Display the digits. ECX contains the number of
	; digits to display, and EDX points to the first digit.
L3:
	mov   ecx,displaySize	; output format size
	shl   ecx,1         	; multiply by 2
	inc   edi
	mov   edx,OFFSET bufferLHB
	add   edx,edi
	call  WriteString

	popad	; restore 32-bit registers
	ret
WriteHexB ENDP


;-----------------------------------------------------
WriteInt PROC
;
; Writes a 32-bit signed binary integer to standard output
; in ASCII decimal.
; Receives: EAX = the integer
; Returns:  nothing
; Comments: Displays a leading sign, no leading zeros.
;-----------------------------------------------------
WI_Bufsize = 12
true  =   1
false =   0
.data
buffer_B  BYTE  WI_Bufsize dup(0),0  ; buffer to hold digits
neg_flag  BYTE  ?

.code
	 pushad

	 mov   neg_flag,false    ; assume neg_flag is false
	 or    eax,eax             ; is AX positive?
	 jns   WIS1              ; yes: jump to B1
	 neg   eax                ; no: make it positive
	 mov   neg_flag,true     ; set neg_flag to true

WIS1:
	 mov   cx,0              ; digit count = 0
	 mov   di,OFFSET buffer_B
	 add   di,(WI_Bufsize-1)
	 mov   ebx,10             ; will divide by 10

WIS2:
	 mov   edx,0              ; set dividend to 0
	 div   ebx                ; divide AX by 10
	 or    dl,30h            ; convert remainder to ASCII
	 dec   di                ; reverse through the buffer
	 mov   [di],dl           ; store ASCII digit
	 inc   cx                ; increment digit count
	 or    eax,eax             ; quotient > 0?
	 jnz   WIS2              ; yes: divide again

	 ; Insert the sign.

	 dec   di	; back up in the buffer
	 inc   cx               	; increment counter
	 mov   byte ptr [di],'+' 	; insert plus sign
	 cmp   neg_flag,false    	; was the number positive?
	 jz    WIS3              	; yes
	 mov   byte ptr [di],'-' 	; no: insert negative sign

WIS3:	; Display the number
	mov  dx,di
	call WriteString

	popad
	ret
WriteInt ENDP


;--------------------------------------------------------
WriteString PROC
; Writes a null-terminated string to standard output
; Receives: DS:DX points to the string
; Returns: nothing
; Last update: 08/02/2002
;--------------------------------------------------------
	pusha
	INVOKE Str_length,dx   		; AX = string length
	mov  cx,ax        		; CX = number of bytes
	mov  ah,40h       		; write to file or device
	mov  bx,1         		; standard output handle
	int  21h          		; call MS-DOS
	popa
	ret
WriteString ENDP

END