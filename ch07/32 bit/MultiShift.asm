; Multiple Doubleword Shift            (MultiShf.asm)

; This program demonstrates a multibyte shift operation, 
; using SHR and RCR instructions.

INCLUDE Irvine32.inc

.data
ArraySize = 3
array BYTE ArraySize DUP(99h)		; 1001 pattern in each nybble

.code
main PROC
	call DisplayArray			; display the array
	
	mov esi,0
	shr array[esi+2],1     		; high byte
	rcr array[esi+1],1     		; middle byte, include Carry flag
	rcr array[esi],1     		; low byte, include Carry flag

	call DisplayArray			; display the array
	exit
main ENDP

;----------------------------------------------------
DisplayArray PROC
; Display the bytes from highest to lowest
;----------------------------------------------------
	pushad

	mov ecx,ArraySize
	mov esi,ArraySize-1
L1:
	mov  al,array[esi]
	mov  ebx,1				; size = byte
	call WriteBinB				; display binary bits
	mov  al,' '
	call WriteChar
	sub  esi,1
	Loop L1
	
	call Crlf
	popad
	ret
DisplayArray ENDP

END main