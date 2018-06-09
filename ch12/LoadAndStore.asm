; Load and Store (floats)       (LoadAndStore.asm)

; This program demonstrates the use of Load and Store 
; instructions in the FPU instruction set.

INCLUDE Irvine32.inc

.code
main PROC

.data
dblOne   REAL8  1234.56
dblTwo   REAL8  10.1

dblThree REAL8 ?
dblFour  REAL8 ?

bigVal   REAL10 1.0123456789012345E+864

.code
	finit
	
; Load a large value onto the stack, pop it 
; back into the same variable.
	fld	bigVal	
	fstp	bigVal

; Load two operands onto the stack
	fld	dblOne
	fld	dblTwo
	call	ShowFPUStack
	
; Store operands into memory, pop from stack	
	fstp	dblThree
	call	ShowFPUStack

	fstp	dblFour
	call	ShowFPUStack
	
    exit
main ENDP

END main