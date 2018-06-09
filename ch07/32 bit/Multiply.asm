; Multiplication Examples             (Multiply.asm)

; This program shows examples of both signed and unsigned multiplication.

INCLUDE Irvine32.inc

.code
main PROC

	mov ax,255
	mov bx,255
	imul bx

;Example 1
	mov al,5h
	mov bl,10h
	mul bl         ; CF = 0

;Example 2
.data
val1  WORD  2000h
val2  WORD  0100h
.code
	mov ax,val1
	mul val2		; CF = 1

;Example 3:
	mov eax,12345h
	mov ebx,1000h
	mul ebx		; CF = 1

; IMUL Examples:

; Example 4:
.data
val3 SDWORD ?
.code
	mov  eax,+4823424
	mov  ebx,-423
	imul ebx			; EDX=FFFFFFFFh, EAX=86635D80h
	mov  val3,eax

	exit
main ENDP
END main