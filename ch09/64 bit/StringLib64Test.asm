; testing 64-bit Windows API			(Lib64test.asm)
;  Chapter 5 example

Str_compare		proto
Str_length		proto
Str_copy			proto
ExitProcess 	proto

.data
source byte "AABCDEFGAABCDFG",0      ; size = 15
target byte 20 dup(0)
.code
main proc
	mov   rax,offset source
	call  Str_length				; returns length in RAX

	mov   rsi,offset source
	mov   rdi,offset target
	call  str_copy

; We just copied the string, so they should be equal:
	
	call  str_compare				; ZF = 1, strings are equal

; Change the first character of the target string, and
; compare them again:

	mov   target,'B'
	call  str_compare				; CF = 1, source < target
	
	mov   ecx,0
	call  ExitProcess
main endp

end