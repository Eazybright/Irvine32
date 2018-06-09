; Mul_and_imul.asm
; Demonstration of the MUL and IMUL instructions
; with 64-bit operands

ExitProcess proto
WriteHex64 proto
Crlf proto

.data
multiplier  qword 10h
.code
main proc
	sub   rsp,28h

	
; 64-bit DIV example
.data
dividend_hi qword 00000108h
dividend_lo qword 33300020h
divisor     qword 00010000h
.code
mov  rdx, dividend_hi
mov  rax, dividend_lo
div  divisor 			; RAX = 0108000000003330
							; RDX = 0000000000000020
	
; IMUL examples	
	mov   rax,-4
	mov   rbx,4
	imul  rbx 			; RAX = -16, RDX = 0FFFFFFFFFFFFFFFF


.data
multiplicand qword -16
.code
imul  rax, multiplicand, 4    ; RAX = FFFFFFFFFFFFFFC0 (-64)
	
	
	
; MUL examples	
	mov   rax,0AABBBBCCCCDDDDh
	mul   multiplier	; RDX:RAX = 00AABBBBCCCCDDDD0
	call  Display		; optional
	
	mov   rax,0FFFF0000FFFF0000h
	mov   rbx,2
	mul   rbx			; RDX:RAX = 1FFFE0001FFFE0000 
	call  Display		; optional
		
	mov   ecx,0			; assign a process return code
	call  ExitProcess	; terminate the program
main endp

Display proc
	; displays RDX:RAX in hexadecimal
	push rax
	mov  rax,rdx
	call WriteHex64
	pop  rax
	call WriteHex64
	call Crlf
	ret
Display endp
end
