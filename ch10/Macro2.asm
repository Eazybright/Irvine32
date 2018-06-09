; Useful Macros                  (Macro2.ASM)

; This program demonstrates several useful macros:
; mGotoxy, mWrite, mWriteLn, mWriteStr, mReadStr,
; and mDumpMem.

INCLUDE Irvine32.inc

;-----------------------------------------------------
mWriteStr MACRO buffer
;
; Improved version of mWriteStr that checks for
; a blank argument.
;-----------------------------------------------------
	IFB <buffer>
	  ECHO -----------------------------------------
	  ECHO *  Error: parameter missing in mWriteStr
	  ECHO *  (no code generated)
	  ECHO -----------------------------------------
	  EXITM
	ENDIF
	push edx
	mov  edx,OFFSET buffer
	call WriteString
	pop  edx
ENDM

;-----------------------------------------------------
mWrite MACRO text
;
; No changes to this macro.
;-----------------------------------------------------
	LOCAL string
	.data		;; local data
	string BYTE text,0		;; define the string
	.code
	push edx
	mov  edx,OFFSET string
	call Writestring
	pop  edx
ENDM

;-----------------------------------------------------
; This version supplies a default argument.

mWriteLn MACRO text := < " " >
;-----------------------------------------------------
	mWrite text
	call Crlf
ENDM

;-----------------------------------------------------
mGotoxyConst MACRO X:REQ, Y:REQ
;
; Set the cursor position
; This version checks the ranges of X and Y.
; are not used.
;------------------------------------------------------
	LOCAL ERRS	;; local constant
	ERRS = 0
	IF (X LT 0) OR (X GT 79)
	   ECHO Warning: First argument to mGotoxy (X) is out of range.
	   ECHO ********************************************************
	   ERRS = 1
	ENDIF
	IF (Y LT 0) OR (Y GT 24)
	   ECHO Warning: Second argument to mGotoxy (Y) is out of range.
	   ECHO ********************************************************
	   ERRS = ERRS + 1
	ENDIF
	IF ERRS GT 0	;; if errors found,
	  EXITM	;; exit the macro
	ENDIF
	push edx
	mov  dh,Y
	mov  dl,X
	call Gotoxy
	pop  edx
ENDM

;------------------------------------------------------
mReadStr MACRO bufferPtr, maxChars
;
; Read from standard input into a buffer.
; EDX cannot be the second argument.
;------------------------------------------------------
	IFIDNI <maxChars> , <EDX>
	   ECHO Warning: EDX cannot be second argument to mReadStr.
	   ECHO ***************************************************
	   EXITM
	ENDIF
	push ecx
	push edx
	mov  edx,bufferPtr
	mov  ecx,maxChars
	call ReadString
	pop  edx
	pop  ecx
ENDM

;---------------------------------------------------
ShowRegister MACRO regName
             LOCAL tempStr
;
; Display a register's name and contents.
;---------------------------------------------------
.data
tempStr BYTE "  &regName=",0
.code
	push eax

; Display the register name
	push edx
	mov  edx,offset tempStr
	call WriteString
	pop  edx

; Display the register contents
	mov  eax,regName
	call WriteHex
	pop  eax
ENDM

.data
message BYTE "Hello there",0
buffer BYTE 50 DUP(?)


BadYValue TEXTEQU <Warning: Y-coordinate is !> 24>

ShowWarning MACRO message
	mWrite "&message"
ENDM

count = 4
sumVal TEXTEQU %5 + count        ; sumVal = 9

.code
main PROC
	mGotoxyConst %5 * 10, %3 + 4

	;ShowWarning %BadYValue

	call Crlf
	call Crlf

	ShowRegister ECX

	mReadStr OFFSET buffer,50	; ok

	mov edx,50
	;mReadStr buffer,edx	; generates warning

	mGotoxyConst 10,20

	mWrite "Line one"
	mWriteLn	; missing argument
	mWriteLn "Line two"

	mWrite <"Line three",0dh,0ah>

	;mWriteStr	; missing argument

	exit
main ENDP
END main