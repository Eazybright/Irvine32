; Encryption Program               (Encrypt.asm)

; This program uses MS-DOS function calls to
; read and encrypt a file. Run it from the
; command prompt, using redirection:

;    Encrypt < infile.txt > outfile.txt

; Function 6 is also used for output, to avoid
; filtering ASCII control characters.
; Last update: 06/01/2006

INCLUDE Irvine16.inc
XORVAL = 239			; any value between 0-255
.code
main PROC
	mov   ax,@data
	mov   ds,ax

L1:
	mov	ah,6			; direct console input
	mov	dl,0FFh		; don't wait for character
	int	21h			; AL = character
	jz	L2			; quit if ZF = 1 (EOF)
	xor	al,XORVAL
	mov	ah,6			; write to output
	mov	dl,al
	int	21h
	jmp	L1			; repeat the loop

L2:	exit
main ENDP
END  main