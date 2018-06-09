; String Library Demo	(StringDemo.asm)

; This program demonstrates the string-handling procedures in 
; the book's link library.

INCLUDE Irvine32.inc

.data
string_1 BYTE "abcde////",0
string_2 BYTE "ABCDE",0
msg0     BYTE "string_1 in upper case: ",0
msg1     BYTE "string1 and string2 are equal",0
msg2     BYTE "string_1 is less than string_2",0
msg3     BYTE "string_2 is less than string_1",0
msg4     BYTE "Length of string_2 is ",0
msg5     BYTE "string_1 after trimming: ",0

.code
main PROC

	call	trim_string
	call	upper_case
	call	compare_strings
	call	print_length

	exit
main ENDP

trim_string PROC
; Remove trailing characters from string_1.

	INVOKE Str_trim, ADDR string_1,'/'
	mov	    edx,OFFSET msg5
	call	WriteString
	mov	    edx,OFFSET string_1
	call	WriteString
	call	Crlf

	ret
trim_string ENDP

upper_case PROC
; Convert string_1 to upper case.

	mov	    edx,OFFSET msg0
	call	WriteString
	INVOKE  Str_ucase, ADDR string_1
	mov	    edx,OFFSET string_1
	call	WriteString
	call	Crlf

	ret
upper_case ENDP

compare_strings PROC
; Compare string_1 to string_2.

	INVOKE Str_compare, ADDR string_1, ADDR string_2
	.IF ZERO?
	mov	edx,OFFSET msg1
	.ELSEIF CARRY?
	mov	edx,OFFSET msg2     ; string 1 is less than...
	.ELSE
	mov	edx,OFFSET msg3     ; string 2 is less than...
	.ENDIF
	call	WriteString
	call	Crlf

	ret
compare_strings  ENDP

print_length PROC
; Display the length of string_2.

	mov	    edx,OFFSET msg4
	call	WriteString
	INVOKE  Str_length, ADDR string_2
	call	WriteDec
	call	Crlf

	ret
print_length ENDP

END main