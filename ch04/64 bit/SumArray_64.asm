; Summing an Array (SumArray_64.asm)
; This program sums an array of words.
; The LOOP instruction requires the /LARGEADDRESSAWARE linker switch to equal NO.

ExitProcess proto
.data
intarray QWORD 1000000000000h,2000000000000h
	     QWORD 3000000000000h,4000000000000h

.code
main proc

	mov  rdi,OFFSET intarray		; 1: RDI = address of intarray
	mov  rcx,LENGTHOF intarray		; 2: initialize loop counter
	mov  rax,0						; 3: sum = 0
L1:									; 4: mark beginning of loop
	add  rax,[rdi]					; 5: add an integer
	add  rdi,TYPE intarray   		; 6: point to next element
	loop L1							; 7: repeat until RCX = 0

	mov  ecx,0						; ExitProcess return value
	call ExitProcess
main endp
end