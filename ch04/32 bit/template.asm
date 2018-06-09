; Program template

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	; declare variables here
.code
main proc
	; write your code here

	invoke ExitProcess,0
main endp
end main