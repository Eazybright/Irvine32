; Procedure prototypes				(Prototypes.asm)
 
; This program demonstrates the limited amount of  
; argument checking by MASM.

INCLUDE Irvine32.inc

.data
byte_1  BYTE  10h
word_1  WORD  2000h
word_2  WORD  3000h
dword_1 DWORD 12345678h

.code
Sub1 PROTO, p1:BYTE, p2:WORD, p3:PTR BYTE


main PROC

	invoke Sub1, byte_1, word_1, ADDR byte_1		; ok

	invoke Sub1, byte_1, byte_1, ADDR byte_1		; no error detected

	
;	invoke Sub1, word_1, word_2, ADDR byte_1		; arg 1 error
	
	invoke Sub1, byte_1, word_2, dword_1			; no error detected
	
;	invoke Sub1, byte_1, word_2					; error: too few arguments
	
;	invoke Sub1, byte_1, 
;	  word_2, ADDR byte_1, word_2					; error: too many arguments


	exit
main ENDP



Sub1 PROC, p1:BYTE, p2:WORD, p3:PTR BYTE

	ret
Sub1 ENDP


END main
