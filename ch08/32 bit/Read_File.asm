; Read_File procedure					(Read_File.asm)

; Demonstrates MASM-generated code.
; View the generated code in the Disassembly window 
; when running in Debug mode.

INCLUDE Irvine32.inc
.data
buffer BYTE 4096 DUP(0)
.code
main PROC

	push offset buffer
	call Read_File

	exit
main ENDP

Read_File PROC USES eax ebx,
	pBuffer:PTR BYTE
	LOCAL fileHandle:DWORD

	mov esi,pBuffer
	mov fileHandle,eax
	pop ebx
	pop eax
	leave
	ret 4
Read_File ENDP

END main