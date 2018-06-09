; Endless Recursion               (Endless.asm)

; This program demonstrates nonstop recursion. It
; causes a stack overflow.

.386
.model flat,stdcall
.stack 0FFFFFh
ExitProcess PROTO, dwExitCode:dword

.code
main PROC
	call Endless
	INVOKE ExitProcess, 0
main ENDP

.code
Endless PROC

	call Endless
	ret				; never reaches this line
Endless ENDP
END main