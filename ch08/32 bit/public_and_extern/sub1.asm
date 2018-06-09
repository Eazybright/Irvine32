; sub1.asm

.386
.model flat,STDCALL

INCLUDE vars.inc

SYM1 = 10			; public

.data
count DWORD 0		; public

END



.code
sub1 PROC 		; public by default

	call localProc

sub1 ENDP

localProc PROC PRIVATE	; private

	ret
localProc ENDP

