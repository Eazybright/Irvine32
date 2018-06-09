; Copying Strings                    (CopyStr.asm)

; Testing the Str_copy procedure

INCLUDE Irvine32.inc

Str_copy PROTO,
 	source:PTR BYTE, 		; source string
 	target:PTR BYTE		; target string

Str_length PROTO,
	pString:PTR BYTE		; pointer to string

.data
string_1 BYTE "ABCDEFG",0
string_2 BYTE 100 DUP(?)

.code
main PROC
	call Clrscr

	INVOKE Str_copy,		; copy string_1 to string_2
	  ADDR string_1,
	  ADDR string_2

	mov  edx,OFFSET string_2
	call WriteString
	call Crlf

	exit
main ENDP

END main
