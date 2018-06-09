;  College Registration Example         (Regist.asm)

; Simple demonstration of MASM's .IF,
; .ENDIF, and .ELSEIF directives.

INCLUDE Irvine32.inc

.data
TRUE = 1
FALSE = 0
gradeAverage  WORD 275	; test value
credits       WORD 12	; test value
OkToRegister  BYTE ?

.code
main PROC

	mov OkToRegister,FALSE

	.IF gradeAverage > 350
	   mov OkToRegister,TRUE
	.ELSEIF (gradeAverage > 250) && (credits <= 16)
	   mov OkToRegister,TRUE
	.ELSEIF (credits <= 12)
	   mov OkToRegister,TRUE
	.ENDIF

	exit
main ENDP

END main