; Fibonacci Numbers            (Finbon.asm)

; This program shows how use the WHILE directive
; to generate doubleword variables containing
; all Fibonacci numbers less than a given limit.

INCLUDE Irvine32.inc

.data
val1  = 1
val2  = 1
DWORD val1		; first two values
DWORD val2
val3 = val1 + val2

WHILE val3 LT 0F0000000h
	DWORD val3
	val1 = val2
	val2 = val3
	val3 = val1 + val2
ENDM

.code
main PROC



	exit
main ENDP
END main