TITLE PrintArray Procedure                  (PrintArray.asm)

INCLUDE Irvine32.inc

.code
;-----------------------------------------------------------
PrintArray PROC USES eax ecx edx esi,
	pArray:PTR DWORD,		; pointer to array
	Count:DWORD			; number of elements
;
; Writes an array of 32-bit signed decimal integers to
; standard output, separated by commas
; Receives: pointer to array, array size
; Returns: nothing
;-----------------------------------------------------------
.data
comma BYTE ", ",0
.code
	mov	esi,pArray
	mov	ecx,Count
	cld				; direction = forward

L1:	lodsd			; load [ESI] into EAX
	call	WriteInt		; send to output
	mov	edx,OFFSET comma
	call	Writestring	; display comma
	loop	L1

	call	Crlf
	ret
PrintArray ENDP

END