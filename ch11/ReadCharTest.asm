; Testing ReadChar             (ReadCharTest.asm)

INCLUDE Irvine32.inc

.code
main PROC

	call	ReadChar
	call	DumpRegs

	exit
main ENDP
END main