TITLE Test the Irvine32 Link Library      (LibTest.asm)

; Use this program to test the Irvine32.asm library.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.data
val1 REAL8	1.2
val2 REAL8	3.4

.code
main PROC

	fld	val1
	fld	val2
	call	ShowFPUStack
	
	fmul
	call	ShowFPUStack

    exit
main ENDP

END main