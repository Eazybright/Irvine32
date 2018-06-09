; Testing the Link Library 	        (Test16.asm)

; Use this program to test individual Irvine16
; library procedures.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.code
main PROC
	mov ax,@data
	mov ds,ax

	call ReadHex
	call DumpRegs

	exit
main ENDP
END main