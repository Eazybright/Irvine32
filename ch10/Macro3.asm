; Using Macro Conditional Expressions          (Macro3.asm)

; The MUL32 macro issues a warning and exits if EAX
; is passed as the second argument. The Text macro LINENUM
; must be defined first. Then, the % (expansion operator)
; in the first column of the line containing the ECHO statement
; causes LINENUM to be expanded into the source file line
; number where the macro is being expanded. It is important
; to define LINENUM inside the macro--otherwise, it just
; returns the line number where LINENUM is declared.

INCLUDE Irvine32.inc

MUL32 MACRO op1, op2, product
	IFIDNI <op2>,<EAX>
	  LINENUM TEXTEQU %(@LINE)
	  ECHO --------------------------------------------------
%	  ECHO *  Error on line LINENUM: EAX cannot be the second
	  ECHO *  argument when invoking the MUL32 macro.
	  ECHO --------------------------------------------------
	EXITM
	ENDIF
	push eax
	mov  eax,op1
	mul  op2
	mov  product,eax
	pop  eax
ENDM

.data
val1 DWORD 1234h
val2 DWORD 1000h
val3 DWORD ?
array DWORD 1,2,3,4,5,6,7,8

.code
main PROC
; The following do not evaluate SIZEOF:
	ECHO The array contains (SIZEOF array) bytes
	ECHO The array contains %(SIZEOF array) bytes

; Using the Expansion (%) operator at the beginning of a line:
	TempStr TEXTEQU %(SIZEOF array)
	%  ECHO The array contains TempStr bytes


    ;MUL32 val1,val2,val3		; val3 = val1 * val2

	mov eax,val2
	MUL32 val1,EAX,val3			; issues a warning

    exit
main ENDP
END main