; Swap Procedure Example                 (Swap.asm)

; This program demonstrates a procedure that exchanges
; two integers using their pointers. Shows how to use
; PROTO, PROC, and INVOKE.

INCLUDE Irvine32.inc

Swap PROTO,			; procedure prototype
	pValX:PTR DWORD,
	pValY:PTR DWORD

.data
Array  DWORD  10000h,20000h

.code
main PROC

	; Display the array before the exchange:
	
	mov  esi,OFFSET Array
	mov  ecx,2				; count = 2
	mov  ebx,TYPE Array
	call DumpMem				; dump the array values

	INVOKE Swap,ADDR Array, ADDR [Array+4]

	; Display the array after the exchange:
	
	call DumpMem

	exit
main ENDP

;-------------------------------------------------------
Swap PROC USES eax esi edi,
	pValX:PTR DWORD,	; pointer to first integer
	pValY:PTR DWORD	; pointer to second integer
;
; Exchange the values of two 32-bit integers
; Returns: nothing
;-------------------------------------------------------
	mov esi,pValX		; get pointers
	mov edi,pValY
	mov eax,[esi]		; get first integer
	xchg eax,[edi]		; exchange with second
	mov [esi],eax		; replace first integer
	ret
Swap ENDP

END main