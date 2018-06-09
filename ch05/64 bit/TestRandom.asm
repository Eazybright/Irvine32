; Testing the Random Number generator		(TestRandom.asm)
; Chapter 5 example

ExitProcess PROTO
WriteInt64  PROTO
Crlf        PROTO
Random64	PROTO
RandomRange PROTO
Randomize   PROTO

.code
main proc
	sub   rsp,8				; align the stack pointer
	sub   rsp,20h			; reserve 32 bytes for shadow parameters

	call  Randomize
	mov   rcx,20
L1:
	mov   rax,234324243242
	call  RandomRange			; returns RAX = random value	
	call  WriteInt64
	call  Crlf
	loop  L1


	add  rsp,28h			; restore stack pointer (optional)
	mov  ecx,0
	call ExitProcess
main endp

end