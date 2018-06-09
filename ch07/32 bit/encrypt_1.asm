; Binary Encryption Example         (Encrypt_1.asm)

INCLUDE Irvine32.inc

BufSize = 80

.data
buffer BYTE BufSize DUP(0)

Key	BYTE 2,5,7,12
prompt1 BYTE "Enter a plaintext message: ",0
msg1	BYTE "The cyphertext text is: ",0
msg2	BYTE "The decrypted text is:  ",0

.code
main PROC

	mov	edx,OFFSET prompt1
	call	WriteString
	mov	edx,OFFSET buffer
	mov	ecx,BufSize
	call	ReadString
	
	call	Encrypt
	
	mov	edx,OFFSET msg1
	call	WriteString
	mov	edx,OFFSET buffer
	call	WriteString

	call Crlf
	exit
main ENDP

;---------------------------------------------------------
Encrypt PROC
;
; Encrypts/Decrypts a string.
; Receives: ESI points to string, EDI points to key array
; Returns: nothing, but buffer is encrypted
;---------------------------------------------------------

	push	ecx
	push	esi
	

	pop	esi
	pop	ecx
	ret
Encrypt ENDP

END main