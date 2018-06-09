; Comparing Strings                    (Compare.asm)

; This program tests the Str_compare procedure,
; which compares two null-terminated strings.

INCLUDE Irvine32.inc

Str_compare PROTO,
	string1:PTR BYTE,
	string2:PTR BYTE

.data
string_1 BYTE "ABCDEFG",0
string_2 BYTE "ABCDEFG",0
string_3 BYTE 0
string_4 BYTE 0

.code
main PROC
	call Clrscr

	INVOKE Str_compare,
	  ADDR string_4,
	  ADDR string_3
	Call DumpRegs

	exit
main ENDP

END main