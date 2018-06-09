; Comparing Floating-Point Values		(FCompare.asm)

; This program demonstrates ways of comparing
; floating-point values.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.code
main PROC

	call compare_for_equality
	call compare_for_inequality

	exit
main ENDP

;--------------------------------------------------
compare_for_equality PROC
;--------------------------------------------------
.data
epsilon REAL8 1.0E-12
val2 REAL8 0.0					; value to compare
val3 REAL8 1.001E-13			; considered equal to val2

.code 
; if( val2 == val3 )
;    display "Values are equal"

	fld	epsilon
	call	ShowFPUStack
	
	fld	val2
	call	ShowFPUStack
	
	fsub	val3
	call	ShowFPUStack
	
	fabs
	call	ShowFPUStack
	
	fcomi	ST(0),ST(1)
	ja	skip
	mWrite <"Values are equal",0dh,0ah> 
	
skip:
	ret
compare_for_equality ENDP


;--------------------------------------------------
compare_for_inequality PROC
;--------------------------------------------------
.data
X REAL8  1.3
Y REAL8  1.2
N DWORD 0
.code
	finit
	
; REQUIRES A P6 PROCESSOR:

; if( X < Y)		
;   N = 1;

	mov	N,0				; initialize N
	fld	Y
	fld	X				; ST(0)=X, ST(1)=Y 
	fcomi ST(0),ST(1)		; compare ST(0) to ST(1)
	jae	L1
	mov	N,1				; N = 1
L1:	
	mWrite "N = "
	mov	eax,N
	call	WriteDec
	call Crlf

; WORKS FOR ALL IA-32 PROCESSORS:

	mov	N,0				; initialize N
	fld	X
	fcomp Y				; compare ST(0) to Y
	fnstsw ax				; move status word into AX
	sahf					; copy AH into EFLAGS
	jnb	L2				; not greater? skip
	mov	N,1				; N = 1
L2:	
	mWrite "N = "
	mov	eax,N
	call	WriteDec
	call Crlf

	ret
compare_for_inequality ENDP

END main


