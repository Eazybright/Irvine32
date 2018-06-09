; Upper Case Conversion                  (Ucase.asm)

; This program tests the Str_ucase procedure, which converts 
; the letters in a string to uppercase.

INCLUDE Irvine32.inc

Str_ucase PROTO,
	pString:PTR BYTE

.data
string_1 BYTE "abcdef",0
string_2 BYTE "aB234cdEfg",0
string_3 BYTE 0

.code
main PROC
	call Clrscr

	INVOKE Str_ucase,ADDR string_1
	INVOKE Str_ucase,ADDR string_2
	INVOKE Str_ucase,ADDR string_3

	exit
main ENDP

END main