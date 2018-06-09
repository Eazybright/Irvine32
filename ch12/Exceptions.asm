; Unmasking an Exception  	(Exceptions.asm)

; This program shows how to mask (set) and unmask (clear) the divide by zero
; exception flag.

INCLUDE Irvine32.inc

.data
ctrlWord WORD ?
val1 DWORD 1
val2 REAL8 0.0

.code
main PROC
	finit		; initialize FPU (divide by zero is masked)

; By unmasking, we enable the divide by zero exception.

	fstcw	ctrlWord				; get the control word
	and	ctrlWord,1111111111111011b	; unmask Divide by 0
	fldcw	ctrlWord				; load it back into FPU

	fild	val1
	fdiv	val2						; divide by zero
	fst	val2
	
	exit
main ENDP
END main