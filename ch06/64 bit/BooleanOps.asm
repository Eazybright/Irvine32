; Moves.asm  - Testing the 64-bit move operations

ExitProcess proto

.data
hexval qword 0123456789ABCDEFh
allones qword 0FFFFFFFFFFFFFFFFh
testval qword ?

.code
main proc
; The AND instruction 

; The destination is a 64-bit register:
	mov  rax,allones
	and  rax,80h				; affects all bits
	mov  rax,allones
	and  rax,8080h				; affects all bits
	mov  rax,allones
	and  rax,808080h			; affects all bits
	mov  rax,allones
	and  rax,80808080h		; affects lower 32 bits

; The destination is a memory operand:	
	mov  rax,allones
	mov  testval,rax
	and  testval,80h				; affects all bits
	
	mov  testval,rax
	and  testval,8080h				; affects all bits
	
	mov  testval,rax
	and  testval,80808080h		; only affects the lower 32 bits

; When a 64-bit register operand is used, AND is a 64-bit operation:
	mov   rax,hexval
	mov   rbx,80808080h
	and   rax,rbx			; affects all bits

	mov   ecx,0
	call  ExitProcess
main endp

end