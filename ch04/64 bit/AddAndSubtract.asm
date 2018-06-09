; Moves.asm  - Testing the 64-bit move operations

ExitProcess proto

.data
initval qword 0
myByte byte 55h
myWord word 6666h
myDword dword 80000000h

.code
main proc
; Moving immediate values:
	mov  rax,0FFFFFFFFh
	add  rax,1					; RAX = 100000000h
	
	mov  rax,0FFFFh
	mov  bx,1
	add  ax,bx					; RAX = 0
	
	mov  rax,0
	mov  ebx,1
	sub  eax,ebx				; RAX = 00000000FFFFFFFF

	mov  rax,0
	mov  bx,1
	sub  ax,bx					; RAX = 000000000000FFFF

	mov  rax,0FFh
	mov  bl,1
	add  al,bl					; RAX = 0
	
	mov  rcx,OFFSET myByte
	inc  BYTE PTR [rcx]					; requires BYTE PTR
	dec  BYTE PTR [rcx]
	
	
	
	mov   ecx,0
	call  ExitProcess
main endp

end