; Testing the USES Operator         (UsesTest.asm)

; This program demonstrates the USES operator with explicit 
; stack parameters

INCLUDE Irvine32.inc

.code
main PROC

	push	5
	call	MySub1
	push	6
	call	MySub2

	exit
main ENDP

; One stack parameter, no USES clause.

MySub PROC
	push	ebp			; save base pointer
	mov	ebp,esp		; base of stack frame
	push	ecx	
	push	edx			; save EDX
	mov	eax,[ebp+8]	; get the stack parameter
	
	pop	edx			; restore saved registers
	pop	ecx
	pop	ebp			; restore base pointer
	ret	4			; clean up the stack
MySub ENDP


; USES without any stack parameters

MySub1 PROC USES ecx edx
	
	
	ret
MySub1 ENDP

; USES with one explicit stack parameter.

MySub2 PROC USES ecx edx
	push	ebp			; save base pointer
	mov	ebp,esp		; base of stack frame

	mov	eax,[ebp+16]	; get the stack parameter
	
	pop	ebp			; restore base pointer
	ret	4			; clean up the stack
MySub2 ENDP


END main