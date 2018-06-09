; Floating-Point Expressions          (Expressions.asm)

; This program shows how different mathematical
; expressions are coded in floating-point instructions.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.code
main PROC
	finit

;---------------- Test FIDIV -------------------
.data
intOne WORD 20
intTwo WORD 10
.code
	fild	intOne
	fidiv	intTwo
	call	ShowFPUStack
	exit

; ------------------ Calculate X^Y ------------
.data
xVal REAL8 2.0
yVal REAL8 5.0
.code
	fld	yVal			; 5
	f2xm1
	call	ShowFPUStack	; 2^5 - 1

	fld	yVal
	fld	xVal
	fyl2X
	call	ShowFPUStack	; X = ST(0)
	f2xm1
	call	ShowFPUStack	; X = ST(0)
	fincstp
	call	ShowFPUStack	; X = ST(0)

; ---------- Calculate a Dot Product ---------

.data
array REAL4 6.0, 2.0, 4.5, 3.2
dotProduct REAL4 ?
.code
	fld	array		; load 6.0 into ST(0)
	call	ShowFPUStack
	fmul	[array+4]		; ST(0) *= 2.0
	call	ShowFPUStack
	fld	[array+8]		; load 4.5 into ST(0)
	call	ShowFPUStack
	fmul	[array+12]	; ST(0) *= 3.2
	call	ShowFPUStack
	fadd				; ST(0) += ST(1)
	call	ShowFPUStack
	fstp	dotProduct  	; store ST(0) to mem

; ------------ Suming an array of reals ---------------
ARRAY_SIZE = 20
.data
sngArray  REAL8  ARRAY_SIZE DUP(1.5)
intval DWORD ?
.code
	
	mov	esi,0		; array index
	fldz				; push 0.0 on stack
	mov	ecx,ARRAY_SIZE

L1:	fld	sngArray[esi]	; add mem into ST(0)
	fadd				; add ST(0), ST(1), pop
	add	esi,TYPE REAL8
	loop	L1

	mWrite "The sum is: "
	call	WriteFloat
	call	Crlf
	
; ---------- Sum of two Square Roots ----------------
.data
valA REAL8 25.0
valB REAL8 36.0
.code
	fld	valA			; push valA
	fsqrt			; ST(0) = sqrt(valA)
	fld	valB			; push valB
	fsqrt			; ST(0) = sqrt(valB)
	fadd				; add ST(0), ST(1)
	call	WriteFloat
	call	Crlf

    exit
main ENDP

END main