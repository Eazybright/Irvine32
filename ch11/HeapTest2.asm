; Heap Test #2                     (Heaptest2.asm)

INCLUDE Irvine32.inc

; Creates a heap and allocates multiple memory blocks, 
; expanding the heap until it fails.

.data
HEAP_START =   2000000	;   2 MB
HEAP_MAX  =  400000000	; 400 MB
BLOCK_SIZE =    500000	;  .5 MB

hHeap DWORD ?			; handle to the heap
pData DWORD ?			; pointer to block

str1 BYTE 0dh,0ah,"Memory allocation failed",0dh,0ah,0

.code
main PROC
	INVOKE HeapCreate, 0,HEAP_START, HEAP_MAX

	.IF eax == NULL		; failed?
	call	WriteWindowsMsg
	call	Crlf
	jmp	quit
	.ELSE
	mov	hHeap,eax 		; success
	.ENDIF

	mov	ecx,2000			; loop counter

L1:	call allocate_block		; allocate a block
	.IF Carry?			; failed?
	mov	edx,OFFSET str1	; display message
	call	WriteString
	jmp	quit
	.ELSE				; no: print a dot to
	mov	al,'.'			; show progress
	call	WriteChar
	.ENDIF
	
	;call free_block		; enable or disable this line
	loop	L1
	
quit:
	INVOKE HeapDestroy, hHeap	; destroy the heap
	.IF eax == NULL			; failed?
	call	WriteWindowsMsg		; yes: error message
	call	Crlf
	.ENDIF

	exit
main ENDP

allocate_block PROC USES ecx

	INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, BLOCK_SIZE
	
	.IF eax == NULL
	   stc				; return with CF = 1
	.ELSE
	   mov  pData,eax		; save the pointer
	   clc				; return with CF = 0
	.ENDIF

	ret
allocate_block ENDP

free_block PROC USES ecx

	INVOKE HeapFree, hHeap, 0, pData
	ret
free_block ENDP

END main
