; Comparing Multiplications         (CompareMult.asm)

; This program compares the execution times of two approaches to 
; integer multiplication: Binary shifting versus the MUL instruction.

INCLUDE Irvine32.inc

LOOP_COUNT = 0FFFFFFFFh

.data
intval DWORD 5
startTime DWORD ?

.code
main PROC

; First approach:

	call	GetMseconds	; get start time
	mov	startTime,eax
	
	mov	eax,intval	; multiply now
	call	mult_by_shifting
	
	call	GetMseconds	; get stop time
	sub	eax,startTime
	call	WriteDec		; display elapsed time
	call	Crlf

; Second approach:

	call	GetMseconds	; get start time
	mov	startTime,eax
	
	mov	eax,intval
	call	mult_by_MUL

	call	GetMseconds	; get stop time
	sub	eax,startTime
	call	WriteDec		; display elapsed time
	call	Crlf

	exit
main ENDP


;---------------------------------
mult_by_shifting PROC
;
; Multiplies EAX by 36 using SHL
;    LOOP_COUNT times.
; Receives: EAX
;---------------------------------

	mov	ecx,LOOP_COUNT
	
L1:	push	eax			; save original EAX
	mov	ebx,eax
	shl	eax,5
	shl	ebx,2
	add	eax,ebx
	pop	eax			; restore EAX
	loop	L1
	
	ret
mult_by_shifting ENDP


;---------------------------------
mult_by_MUL PROC
;
; Multiplies EAX by 36 using MUL
;    LOOP_COUNT times.
; Receives: EAX
;---------------------------------

	mov	ecx,LOOP_COUNT
	
L1:	push	eax			; save original EAX
	mov	ebx,36
	mul	ebx
	pop	eax			; restore EAX
	loop	L1
	
	ret
mult_by_MUL ENDP

END main