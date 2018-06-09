; Calculating a Factorial                   (Fact.asm)

; This program uses recursion to calculate the
; factorial of an integer.

INCLUDE Irvine32.inc

.code
main PROC
	push 5			; calculate 5 factorial
	call Factorial		; calculate factorial (eax)
	call WriteDec		; display it
	call Crlf
	exit
main ENDP

Factorial PROC
	push ebp
	mov  ebp,esp
	mov  eax,[ebp+8]	; get n
	cmp  eax,0		; n < 0?
	ja   L1			; yes: continue
	mov  eax,1		; no: return 1
	jmp  L2

L1:	dec  eax
	push eax			; Factorial(n-1)
	call Factorial

; Instructions from this point on execute when each
; recursive call returns.

ReturnFact:
	mov  ebx,[ebp+8]   	; get n
	mul  ebx          	; ax = ax * bx

L2:	pop  ebp			; return EAX
	ret  4			; clean up stack
Factorial ENDP

END main