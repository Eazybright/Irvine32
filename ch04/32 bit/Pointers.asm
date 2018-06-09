; Pointers (Pointers.asm)

; Demonstration of pointers and TYPEDEF.

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

; Create user-defined types.
PBYTE  TYPEDEF PTR BYTE		; pointer to bytes
PWORD  TYPEDEF PTR WORD		; pointer to words
PDWORD TYPEDEF PTR DWORD		; pointer to doublewords

.data
arrayB BYTE  10h,20h,30h
arrayW WORD  1,2,3
arrayD DWORD 4,5,6

; Create some pointer variables.
ptr1 PBYTE  arrayB
ptr2 PWORD  arrayW
ptr3 PDWORD arrayD

.code
main PROC

; Use the pointers to access data.
	mov esi,ptr1
	mov al,[esi]		; 10h
	mov esi,ptr2
	mov ax,[esi]		; 1
	mov esi,ptr3
	mov eax,[esi]		; 4

	invoke ExitProcess,0
main ENDP
END main