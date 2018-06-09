; Demonstrate the AddTwo Procedure     (AddTwo.asm)

; Demonstrates different procedure call protocols.

INCLUDE Irvine32.inc

.data
word1 WORD 1234h
word2 WORD 4111h

.code
main PROC

	;call	Example1
	;call	Example2

	movzx	eax,word1
	push	eax
	movzx	eax,word2
	push	eax
	call	AddTwo
	call	DumpRegs

	exit

main ENDP

; Call the "C" version of AddTwo

Example1 PROC
	push 5
	push 6
	call AddTwo_C
	add  esp,8		; clean up the stack
	call DumpRegs		; sum is in EAX
	ret
Example1 ENDP

; Call the STDCALL version of AddTwo

Example2 PROC
	push 5
	push 6
	call AddTwo
	call DumpRegs		; sum is in EAX
	ret
Example2 ENDP


AddTwo_C PROC
; Adds two integers, return sum in EAX.
; RET does not clean up the stack.
    push ebp
    mov  ebp,esp
    mov  eax,[ebp + 12]   	; first parameter
    add  eax,[ebp + 8]		; second parameter
    pop  ebp
    ret					; caller cleans up the stack
AddTwo_C ENDP

AddTwo PROC
; Adds two integers, returns sum in EAX.
; The RET instruction cleans up the stack.

    push ebp
    mov  ebp,esp
    mov  eax,[ebp + 12]   	; first parameter
    add  eax,[ebp + 8]		; second parameter
    pop  ebp
    ret  8				; clean up the stack
AddTwo ENDP

END main