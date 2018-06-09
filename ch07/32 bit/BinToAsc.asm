; Binary to ASCII                    (BinToAsc.asm)

; This program converts a 32-bit binary integer to ASCII.

INCLUDE Irvine32.inc

.data
binVal	DWORD 1234ABCDh		; sample binary value
buffer	BYTE 32 dup(0),0

.code
main PROC
	mov	eax,binVal			; EAX = binary integer
	mov	esi,OFFSET buffer		; point to the buffer
	call	BinToAsc				; do the conversion

	mov	edx,OFFSET buffer		; display the buffer
	call WriteString			; output: 00010010001101001010101111001101

	call Crlf
	exit
main ENDP

;---------------------------------------------------------
; BinToAsc PROC
;
; Converts 32-bit binary integer to ASCII binary.
; Receives: EAX = binary integer, ESI points to buffer
; Returns: buffer filled with ASCII binary digits
;---------------------------------------------------------

BinToAsc PROC
	push	ecx
	push	esi
	
	mov	ecx,32				; number of bits in EAX

L1:	shl	eax,1				; shift high bit into Carry flag
	mov	BYTE PTR [esi],'0'		; choose 0 as default digit
	jnc	L2					; if no Carry, jump to L2
	mov	BYTE PTR [esi],'1'		; else move 1 to buffer

L2:	inc	esi					; next buffer position
	loop	L1					; shift another bit to left

	pop	esi
	pop	ecx
	ret
BinToAsc ENDP

END main