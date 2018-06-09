; Binary Multiplication         (BMult.asm)

; This program demonstrates binary multiplication using SHL.
; It multiplies intval by 36, using SHL instructions.

INCLUDE Irvine32.inc

.data
intval  DWORD  123

.code
main PROC

	mov	eax,intval
	mov	ebx,eax
	shl	eax,5		; multiply by 32
	shl	ebx,2		; multiply by 4
	add	eax,ebx		; sum the products
	call	DumpRegs

	exit
main ENDP
END main