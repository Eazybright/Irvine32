; 16-bit Floating-Point I/O Test 	(fltTst16.asm)

; Testing floating-point procedures in the Irvine16 library.

INCLUDE Irvine16.inc
INCLUDE macros.inc

.data
first  REAL8 123.456
second REAL8 10.0
third  REAL8 ?

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	finit		; initialize FPU

; Add two floats, display their sum, and
; display the FPU stack.

	fld	first
	fadd	second
	call	WriteFloat
	call	ShowFPUStack

; Input two floats and display their sum.

	mWrite "Please enter a real number: "
	call	ReadFloat
	
	mWrite "Please enter a real number: "
	call	ReadFloat
	
	fadd	ST(0),ST(1)
	
	mWrite "Their sum is: "
	call	WriteFloat
	call	Crlf

	exit
main ENDP
END main