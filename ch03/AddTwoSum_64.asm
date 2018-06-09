; AddTwoSum_64.asm - Chapter 3 example.

ExitProcess proto

.data
sum qword 0

.code
main proc
	mov	  rax,5
	add	  rax,6
	mov   sum,rax

	mov   ecx,0
	call  ExitProcess
main endp
end
