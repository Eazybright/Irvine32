; Trim Trailing Characters             (Trim.asm)

; Test the Trim procedure. Trim removes trailing all
; occurrences of a selected character from the end of
; a string.

INCLUDE Irvine32.inc

Str_trim PROTO,
	pString:PTR BYTE,		; points to string
	char:BYTE				; character to remove

Str_length PROTO,
	pString:PTR BYTE		; pointer to string

ShowString PROTO,
	pString:PTR BYTE

.data
; Test data:
string_1 BYTE 0				; case 1
string_2 BYTE "#",0			; case 2
string_3 BYTE "Hello###",0	; case 3
string_4 BYTE "Hello",0		; case 4
string_5 BYTE "H#",0		; case 5
string_6 BYTE "#H",0		; case 6

.code
main PROC
	call Clrscr

	INVOKE Str_trim,ADDR string_1,'#'
	INVOKE ShowString,ADDR string_1

	INVOKE Str_trim,ADDR string_2,'#'
	INVOKE ShowString,ADDR string_2

	INVOKE Str_trim,ADDR string_3,'#'
	INVOKE ShowString,ADDR string_3

	INVOKE Str_trim,ADDR string_4,'#'
	INVOKE ShowString,ADDR string_4

	INVOKE Str_trim,ADDR string_5,'#'
	INVOKE ShowString,ADDR string_5

	INVOKE Str_trim,ADDR string_6,'#'
	INVOKE ShowString,ADDR string_6

	exit
main ENDP

;-----------------------------------------------------------
ShowString PROC USES edx, pString:PTR BYTE
; Display a string surrounded by brackets.
;-----------------------------------------------------------
.data
lbracket BYTE "[",0
rbracket BYTE "]",0
.code
	mov  edx,OFFSET lbracket
	call WriteString
	mov  edx,pString
	call WriteString
	mov  edx,OFFSET rbracket
	call WriteString
	call Crlf
	ret
ShowString ENDP

END main