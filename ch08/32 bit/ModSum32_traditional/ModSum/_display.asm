; DisplaySum Procedure		(_display.asm)

INCLUDE Irvine32.inc
.code
;-----------------------------------------------------
DisplaySum PROC

; Displays the sum on the console.
; Receives:
;	ptrPrompt		; offset of prompt string
;	theSum		; the array sum (DWORD)
; Returns: nothing
;-----------------------------------------------------

theSum	EQU [ebp+12]
ptrPrompt	EQU [ebp+8]

	enter	0,0
	push	eax
	push	edx

	mov	edx,ptrPrompt	; pointer to prompt
	call	WriteString
	mov	eax,theSum
	call	WriteInt		; display EAX
	call	Crlf

	pop	edx
	pop	eax
	leave
	ret	8		; restore the stack
DisplaySum ENDP
END