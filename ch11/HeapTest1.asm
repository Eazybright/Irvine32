; Heap Test #1                          (Heaptest1.asm)

INCLUDE Irvine32.inc

; This program uses dynamic memory allocation to allocate and 
; fill an array of bytes. 

.data
ARRAY_SIZE = 1000
FILL_VAL EQU 0FFh

hHeap   DWORD ?		; handle to the process heap
pArray  DWORD ?		; pointer to block of memory
newHeap DWORD ?		; handle to new heap
str1 BYTE "Heap size is: ",0

.code
main PROC
	INVOKE GetProcessHeap		; get handle to prog's heap
	.IF eax == NULL			; failed?
	call	WriteWindowsMsg
	jmp	quit
	.ELSE
	mov	hHeap,eax		; success
	.ENDIF

	call	allocate_array
	jnc	arrayOk		; failed (CF = 1)?
	call	WriteWindowsMsg
	call	Crlf
	jmp	quit

arrayOk:				; ok to fill the array
	call	fill_array
	call	display_array
	call	Crlf

	; free the array
	INVOKE HeapFree, hHeap, 0, pArray
	
quit:
	exit
main ENDP

;--------------------------------------------------------
allocate_array PROC USES eax
;
; Dynamically allocates space for the array.
; Receives: nothing
; Returns: CF = 0 if allocation succeeds.
;--------------------------------------------------------
	INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, ARRAY_SIZE
	
	.IF eax == NULL
	   stc				; return with CF = 1
	.ELSE
	   mov  pArray,eax		; save the pointer
	   clc				; return with CF = 0
	.ENDIF

	ret
allocate_array ENDP

;--------------------------------------------------------
fill_array PROC USES ecx edx esi
;
; Fills all array positions with a single character.
; Receives: nothing
; Returns: nothing
;--------------------------------------------------------
	mov	ecx,ARRAY_SIZE			; loop counter
	mov	esi,pArray			; point to the array

L1:	mov	BYTE PTR [esi],FILL_VAL	; fill each byte
	inc	esi					; next location
	loop	L1

	ret
fill_array ENDP

;--------------------------------------------------------
display_array PROC USES eax ebx ecx esi
;
; Displays the array
; Receives: nothing
; Returns: nothing
;--------------------------------------------------------
	mov	ecx,ARRAY_SIZE	; loop counter
	mov	esi,pArray	; point to the array
	
L1:	mov	al,[esi]		; get a byte
	mov	ebx,TYPE BYTE
	call	WriteHexB		; display it
	inc	esi			; next location
	loop	L1

	ret
display_array ENDP

END main
