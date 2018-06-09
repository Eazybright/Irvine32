; Floating-Point PrecisionLoss          (LossOfPrecision.asm)

; This program demonstrates a simple rounding error in 
; often encountered in floating-point operations. Also, the
; program shows how to compare real numbers by examining the
; epsilon (absolute value of the difference) between the numbers.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.code
main PROC
	finit
	call	show_rounding_error
	call	comparing_reals

	exit
main ENDP

;------------------------------------------
show_rounding_error PROC
;------------------------------------------
.data
val1   REAL8 2.0
result REAL8 ?

.code
; multiply sqrt(2.0) * sqrt(2.0)

	fld	val1				; load val1 onto stack
	fsqrt					; calculate its square root
	call	ShowFPUStack
	fmul	ST(0),ST(0)		; st(0) contains the product,
	call	ShowFPUStack	; which appears to equal 2.0
	
; subtract 2.0	from ST(0)
	fsub	val1
	call	ShowFPUStack
	fst	result
	
; Result should be 0.0, but it really equals +4.4408921E-016 	
	ret
show_rounding_error ENDP


;-----------------------------------------------------------
comparing_reals PROC 
;
; Proper way to compare to reals for equality by subtracting
; them from each other and examining the remainder.
;-----------------------------------------------------------
 
.data
epsilon REAL8 1.0E-12
val2    REAL8 0.0
val3    REAL8 1.001E-13		; equal to val2
;val3   REAL8 1.001E-12		; not equal to val2

.code 
; if( val2 == val3 ), display "equal".
; method: 
;	if( abs(val2 - val3) < epsilon ), the values are equal.

	fld		epsilon			; ST(0) = epsilon
	fld		val2			; ST(0) = val2
	fsub	val3			; ST(0) = val2 - val3
	call	ShowFPUStack
	fabs					; ST(0) = ABS(ST(0))
	fcomi	ST(0),ST(1)
	ja		skip
	mWrite <"equal",0dh,0ah>
 
skip: 
	ret
comparing_reals ENDP
 
END main