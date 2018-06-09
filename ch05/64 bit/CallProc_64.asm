; Calling a subroutine in 64-bit mode			(CallProc_64.asm)

extrn ExitProcess: PROC

.code
main proc
	sub  rsp,8           ; align the stack pointer
	sub  rsp,20h			; reserve 32 bytes for shadow parameters

	mov  rcx,1				; pass four parameters, in order
	mov  rdx,2
	mov  r8,3
	mov  r9,4
	call AddFour		; look for return value in RAX

	mov  ecx,0
	call ExitProcess
main endp

AddFour proc
	mov  rax,rcx
	add  rax,rdx
	add  rax,r8
	add  rax,r9				; sum is in RAX
	ret
AddFour endp

end