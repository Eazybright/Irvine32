; Displaying Binary Bits                (WriteBin.asm)

; This program displays a 32-bit integer in binary.

INCLUDE Irvine32.inc

.data
binValue DWORD 1234ABCDh		; sample binary value
buffer BYTE 32 dup(0),0

.code
main PROC

	mov	eax,binValue		; number to display
	mov	ecx,32			; number of bits in EAX
	mov	esi,offset buffer

L1:	shl	eax,1			; shift high bit into Carry flag
	mov	BYTE PTR [esi],'0'	; choose 0 as default digit
	jnc	L2				; if no Carry, jump to L2
	mov	BYTE PTR [esi],'1'	; else move 1 to buffer

L2:	inc  esi				; next buffer position
	loop L1				; shift another bit to left

	mov  edx,OFFSET buffer	; display the buffer
	call WriteString
	call Crlf
	exit
main ENDP
END main