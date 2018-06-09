; Moves.asm  - Testing the 64-bit move operations

ExitProcess proto

.data
message BYTE "Welcome to my 64-bit Library!",0
maxuint qword 0FFFFFFFFFFFFFFFFh
myByte byte 55h
myWord word 6666h
myDword dword 80000000h

.code
main proc
; Moving immediate values:
	mov  rax,maxuint		; fill all bits in RAX
	mov  rax,81111111h		; clears bits 32-63 (no sign extension)
	mov  rax,06666h			; clears bits 16-63
	mov  rax,055h			; clears bits 8-63

; Moving memory operands:
	mov  rax,maxuint		; fill all bits in RAX
	mov  eax,myDword		; clears bits 32-63 (no sign extension)
	mov  ax,myWord			; affects only bits 0-15
	mov  al,myByte			; affects only bits 0-7

; 32-bit sign extension works like this
	mov   myWord,8111h		; make it negative
	movsx eax,myWord			; EAX = FFFF8111h

; The MOVSXD instruction (move with sign-extension) permits the 
; source operand to be a 32-bit register or memory operand:
	mov     ebx,0FFFFFFFFh
	movsxd  rax,ebx				; rax = FFFFFFFFFFFFFFFF	

	mov   ecx,0
	call  ExitProcess
main endp

end