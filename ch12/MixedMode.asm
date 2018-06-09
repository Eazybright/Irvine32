; Mixed-Mode FPU Arithmetic      (MixedMode.asm)

; This program demonstrates mixed-mode arithmetic using 
; reals and integers. Also, it demonstrates the multiplication 
; and division of reals, as well as the SQRT instruction.

INCLUDE Irvine32.inc

.code
main PROC

; ------------- Mixed-mode arithmetic ---------------
; Implement the following expression: Z = (int) (N + X)
.data
N SDWORD 20
X REAL8 3.5
Z SDWORD ?
ctrlWord WORD ?

.code
	finit						; initialize FPU

; Demonstrates rounding upward.
	fild	N						; load integer into ST(0)
	fadd	X						; add mem to ST(0)
	fist	Z 						; store ST(0) to mem int
	mov	eax,Z					; sum: 24

; Demonstrates truncation.
	fstcw ctrlWord					; store control word
	or	 ctrlWord, 110000000000b		; set the RC field to truncate
	fldcw ctrlWord					; load control word
	
	fild	N						; load integer into ST(0)
	fadd	X						; add mem to ST(0)
	fist	Z 						; store ST(0) to mem int
	
	fstcw ctrlWord					; store control word
	and	 ctrlWord, 001111111111b		; reset rounding to default
	fldcw ctrlWord					; load control word
	mov	 eax,Z					; sum: 23

; ------------ Divide two reals ------------------
.data
dblOne   REAL8  1234.56
dblTwo   REAL8  10.0
dblQuot  REAL8  ?
.code
	fld	dblOne		; load into ST(0)
	fdiv	dblTwo		; divide ST(0) by mem
	fstp	dblQuot		; store ST(0) to mem

; ------------- Expression (mult, divide)
; valD = -valA + (valB * valC)

.data
valA REAL8 1.5
valB REAL8 2.5
valC REAL8 3.0
valD REAL8 ?			; +6.0
.code
	fld	valA			; load valA into ST(0)
	fchs				; change its sign
	fld	valB			; load valB into ST(0)
	fmul	valC			; multiply by valC
	fadd				; add ST(1) to ST(0)
	fstp	valD			; store ST(0) to valD

; ---------- Calculate the sum of three reals ----------
.data
sngArray  REAL4  1.5, 3.4, 6.6
sum       REAL4  ?
.code
	fld	sngArray			; load mem into ST(0)
	fadd	[sngArray+4]		; add mem to ST(0)
	fadd	[sngArray+8]		; add mem to ST(0)
	fstp	sum				; store ST(0) to mem

; ---------- Calculate a Square Root ----------------
.data
sngVal1   REAL4 25.0
sngResult REAL4 ?
.code
	fld	sngVal1			; load into ST(0)
	fsqrt				; ST(0) = square root
	fstp	sngResult			; store ST(0) to mem

    exit
main ENDP

END main