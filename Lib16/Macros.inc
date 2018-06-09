.NOLIST
COMMENT !
; (Macros.inc) - Include file containing Macros
; for Assembly Language for Intel-Based Computers
; 4th Edition, by Kip Irvine. Copyright 2002, Prentice-Hall Inc,
; all rights reserved.
;
; Update history:
;    11/18/02: added the mShow macro
;    11/19/02: revised by Gerald Cahill

; List of macros in this file:

mClrscr MACRO
	-- Clear the screen

mDump MACRO varName:REQ, useLabel
	-- Display a variable, using its name and built-in attributes
	-- useLabel is optional; if nonblank, the variable name will be displayed
	--    just before the dump.

mDumpMem MACRO address:REQ, itemCount:REQ, componentSize:REQ
	-- Display a dump of a range of memory

mGotoxy MACRO X:REQ, Y:REQ
	-- Set the cursor position

mReadStr MACRO varName:REQ
	-- Read from standard input into a buffer

mShow MACRO itsName:REQ, format:=<HIN>
	-- Display a variable or register in various formats

mShowRegister MACRO regName, regValue
	-- Display a register name and contents.
	-- (Also named ShowRegister, for compatibility with page 363.)

mWrite MACRO text:REQ
	-- Write a string literal to standard output

mWriteLn MACRO text:REQ
	-- Write a literal string to standard output,
	-- and append an end of line

mWriteStr MACRO buffer:REQ
	-- Write a string variable to standard output

mNewLine MACRO
	--  Send a newline sequence to standard output

mWriteSpace MACRO count
	-- Write one or more spaces to standard output
	-- <count> is optional

END COMMENT ***************************************** !

; Introduced in Chapter 10 as an example of a Macro function.

IsDefined MACRO symbol
    IFDEF symbol
        EXITM <-1>              ;; True
    ELSE
        EXITM <0>               ;; False
    ENDIF
ENDM

; Send a newline sequence to standard output
; Revised 10/29/02

mNewLine MACRO
	mWrite <0dh,0ah>
ENDM

;------------------------------------------------------
mClrscr MACRO
;
; Clear the screen
; Created 10/29/02
;------------------------------------------------------
	call Clrscr
ENDM

;----------------------------------------------------
mDump MACRO varName:REQ, useLabel
;
; Display a variable, using its known attributes
; Receives: varName, the name of a variable.
;    If useLabel is nonblank, the name of the
;    variable is displayed.
; Revised 10/29/02
;----------------------------------------------------
IFB <varName>
	EXITM
ENDIF
	call Crlf
	IFNB <useLabel>
	  mWrite "Variable name: &varName"
	ELSE
	  mWrite " "
	ENDIF
	mDumpMem OFFSET varName, LENGTHOF varName, TYPE varName
ENDM

;------------------------------------------------------
mDumpMem MACRO address:REQ, itemCount:REQ, componentSize:REQ
;
; Display a dump of memory, using the DumpMem procedure.
; Revised 10/29/02
;------------------------------------------------------
IFB <address>
	EXITM
ENDIF
IFB <itemCount>
	EXITM
ENDIF
IFB <componentSize>
	EXITM
ENDIF
	push ebx
	push ecx
	push esi
	mov  esi,address
	mov  ecx,itemCount
	mov  ebx,componentSize
	call DumpMem
	pop  esi
	pop  ecx
	pop  ebx
ENDM

;------------------------------------------------------
mGotoxy MACRO X:REQ, Y:REQ
;
; Set the cursor position
; Revised 10/29/02
;------------------------------------------------------
IFB <X>
	EXITM
ENDIF
IFB <Y>
	EXITM
ENDIF
	push edx
    mov  dh,Y
    mov  dl,X
	call Gotoxy
	pop  edx
ENDM

;------------------------------------------------------
mReadStr MACRO varName:REQ
;
; Read from standard input into a buffer.
; Revised 10/29/02
;------------------------------------------------------
IFB <varName>
	EXITM
ENDIF
	push ecx
	push edx
	mov  edx,OFFSET varName
	mov  ecx,(SIZEOF varName) - 1
	call ReadString
	pop  edx
	pop  ecx
ENDM

;---------------------------------------------------
mShow MACRO itsName:REQ, format:=<HIN>
             LOCAL tempStr
; Display a register's or variable's name and contents.
;
; Receives:
;	itsName is the name of a register or variable.
; 	format is an ordered string consisting of the format codes:
;	  H - hexadecimal
;	  D - unsigned decimal
;     I - signed decimal
;     B - binary
;     N - append a newline (CR/LF) (may appear multiple times)
;
; The default format is "HIN"
;
; The variable or register's value is displayed in each format,
; in the order specified by the caller, on a single output line.
; Created by Kip Irvine and Gerald Cahill
;
; Last update: 11/19/02
;---------------------------------------------------
.data
tempStr BYTE "  &itsName = ",0
.code
    pushad

;;If itsName is a register name, define its type

IF (OPATTR (itsName)) AND 00010000b ;;true if register name

  MSHOWITSNAMETYPE = 0 ;; initialize TYPE to not found

  FOR reg8,<al,ah,bl,bh,cl,ch,dl,dh>
    IFIDNI <itsName>,<reg8>
      MSHOWITSNAMETYPE = 1
      movzx ecx,itsName  ;; get unsigned value
      movsx edx,itsName  ;; get signed value
    ENDIF
  ENDM

  FOR reg16,<ax,bx,cx,dx,si,di,bp,sp>
    IFIDNI <itsName>,<reg16>
      MSHOWITSNAMETYPE = 2
      movzx ecx,itsName  ;; get unsigned value
      movsx edx,itsName  ;; get signed value
    ENDIF
  ENDM

  FOR regseg,<cs,ds,es,fs,gs,ss>
    IFIDNI <itsName>,<regseg>
      MSHOWITSNAMETYPE = 2
      mov   ax,itsName  ;; get value into general purpose reg.
      movsx edx,ax      ;; get signed value (who would want it?)
      movzx ecx,ax      ;; get unsigned value
    ENDIF
  ENDM

  FOR reg32,<eax,ebx,ecx,edx,esi,edi,ebp,esp>
    IFIDNI <itsName>,<reg32>
      MSHOWITSNAMETYPE = 4
      mov   ecx,itsName  ;; get unsigned value
      mov   edx,itsName  ;; get signed value
    ENDIF
  ENDM

ELSE ;; itsName is not a register name, assume variable name

  MSHOWITSNAMETYPE = TYPE itsName
  IF MSHOWITSNAMETYPE EQ 4
      mov   ecx,itsName  ;; get unsigned value
      mov   edx,ecx      ;; get signed value
  ELSE
      movzx ecx,itsName  ;; get unsigned value
      movsx edx,itsName  ;; get signed value
  ENDIF

ENDIF ;;OPATTR
                         ;; Display the register or variable's name
    push edx
    mov  edx,OFFSET tempStr
    call WriteString
    pop  edx

                        ;; Display the register or variable's contents
FORC fmt,<format>

  IFIDNI <fmt>,<H>      ;; H - write unsigned hex
    mov eax,ecx         ;; get unsigned
    mov ebx,MSHOWITSNAMETYPE
    call WriteHexB    	;; write in hexadecimal
    mWrite "h  "
  ENDIF

  IFIDNI <fmt>,<D>      ;; D - write unsigned dec
    mov eax,ecx         ;; get unsigned
    call WriteDec
    mWrite "d  "
  ENDIF

  IFIDNI <fmt>,<I>      ;; I - write signed Integer
    mov eax,edx         ;; get signed
    call WriteInt
    mWrite "d  "
  ENDIF

  IFIDNI <fmt>,<B>      ;; B - write unsigned binary
    mov eax,ecx         ;; get unsigned
    mov ebx,MSHOWITSNAMETYPE
    call WriteBinB      ;; display binary
    mWrite "b  "
  ENDIF

  IFIDNI <fmt>,<N>      ;; N - write new line
    call Crlf
  ENDIF

ENDM ;end FORC

	popad
ENDM 	;; end mShow macro

;---------------------------------------------------
; alternative name for mShowRegister:
ShowRegister TEXTEQU <mShowRegister>
;---------------------------------------------------

;---------------------------------------------------
mShowRegister MACRO regName, regValue
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
	mov  edx,OFFSET tempStr
	call WriteString
	pop  edx

; Display the register contents
	mov  eax,regValue
	call WriteHex
	pop  eax
ENDM

;------------------------------------------------------
mWrite MACRO text:REQ
;
; Write a string literal to standard output
; Revised 10/29/02
;------------------------------------------------------
LOCAL string
IFB <text>
	EXITM
ENDIF
	.data		;; local data
	string BYTE text,0		;; define the string
	.code
	push edx
	mov  edx,OFFSET string
	call WriteString
	pop  edx
ENDM

;------------------------------------------------------
mWriteLn MACRO text:REQ
;
; Write a literal string to standard output, with
; an end of line appended.
; Revised 10/29/02
;------------------------------------------------------
IFB <text>
	EXITM
ENDIF
	mWrite text
	call Crlf
ENDM

;------------------------------------------------------
mWriteSpace MACRO count
;
; Write <count< spaces to standard output
; If count is blank, a single space is written.
; Revised 10/29/02
;------------------------------------------------------
LOCAL spaces
.data
IFB <count>
	spaces BYTE ' ',0
ELSE
	spaces BYTE count DUP(' '),0
ENDIF
.code
	push edx
	mov  edx,OFFSET spaces
	call WriteString
	pop  edx
ENDM

;------------------------------------------------------
mWriteStr MACRO buffer:REQ
;
; Write a string variable to standard output.
; Revised 10/29/02
;------------------------------------------------------
IFB <buffer>
	EXITM
ENDIF
	push edx
	mov  edx,OFFSET buffer
	call WriteString
	pop  edx
ENDM

;----------------------------------------------------------------------
; We may later decide to add some macros that are specific to 32-bit
; mode, or to 16-bit mode. The @MODEL value is defined either by
; Irvine16.inc or by Irvine32.inc, when they use the .MODEL directive.
;----------------------------------------------------------------------

IFDEF @MODEL	; @MODEL defined?
	IF @MODEL EQ 7	; 32-bit unique macros begin here...

	ELSE	; 16-bit unique macros begin here...

	ENDIF	; IF @MODEL...
ENDIF	; IFNDEF @MODEL

.LIST