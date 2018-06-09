;      (proc.asm)

; This program shows how to use the PROC directive with 
; different calling conventions.

INCLUDE Irvine32.inc

.code

Example1 PROTO C,
	parm1:DWORD, parm2:DWORD

Example2 PROTO STDCALL,
	parm1:DWORD, parm2:DWORD

Example3 PROTO PASCAL,
	parm1:DWORD, parm2:DWORD

main PROC

	INVOKE Example1, 2, 3
	INVOKE Example2, 2, 3
	INVOKE Example3, 2, 3
	
	exit

main ENDP


Example1 PROC C,
	parm1:DWORD, parm2:DWORD

	mov	eax,parm1
	mov	ebx,parm2
	call	DumpRegs

	ret
Example1 ENDP


Example2 PROC STDCALL,
	parm1:DWORD, parm2:DWORD
	
	mov	eax,parm1
	mov	ebx,parm2
	call	DumpRegs
	
	ret
Example2 ENDP

Example3 PROC PASCAL,
	parm1:DWORD, parm2:DWORD
	
	mov	eax,parm1
	mov	ebx,parm2
	call	DumpRegs
	
	ret
Example3 ENDP


END main