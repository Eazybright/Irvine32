; IMUL Examples             (imul.asm)

; This program shows exmples of various IMUL formats.

INCLUDE Irvine32.inc

.data
byte1	SBYTE	-4
byte2	SBYTE	+5

.code
main PROC


; Example 1
   mov	al,48
   mov	bl,4
   imul	bl      		; AX = 00C0h, OF = 1


; Example 2
	mov	al,-4
	mov	bl,4
	imul	bl			; AX = FFF0, OF = 0

; Example 3
	mov   ax,48
	mov   bx,4
	imul  bx      		; DX:AX = 000000C0h, OF = 0

; Example 4
	mov   eax,+4823424
	mov   ebx,-423
	imul  ebx			; EDX:EAX = FFFFFFFF86635D80h, OF = 0


; Example 5
.data
word1	SWORD	4
dword1	SDWORD	4

.code
	mov	ax,-16
	mov	bx,2	
	imul	bx,ax		; BX = -32
	imul	bx,2			; BX = -64
	imul	bx,word1		; BX = -256
   	  	   	
	mov	eax,-16
	mov	ebx,2
	imul	ebx,eax		; EBX = -32
	imul	ebx,2		; EBX = -64
	imul	ebx,dword1	; EBX = -256
	
; Example 6

	mov	ax,-32000
	imul	ax,2			; OF = 1, CF = 1
	
; Example 7	

	imul	bx,word1,-16			; BX = -64
	imul	ebx,dword1,-16			; EBX = -64
	imul	ebx,dword1,-2000000000	; OF = 1, CF = 1
	

	exit
main ENDP
END main