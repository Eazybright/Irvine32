; ArraySum Optimization          (ArrySum.asm)

; This program calculates the sum of an array.

INCLUDE Irvine32.inc

Optimized = 1

.data
Array DWORD 50 DUP(5)

.code
main PROC

	push LENGTHOF Array
	push OFFSET Array
	call ArraySum
	add  sp,8
	call WriteDec			; display the sum
	call Crlf

	exit
main ENDP

Comment !

IMPLEMENTING THE FOLLOWING C++ FUNCTION:

int ArraySum( int array[], int count )
{
	int sum = 0;
	for(int i = 0; i < count; i++)
	  sum += array[i];
	return sum;
}
!

sum    EQU <[ebp-4]>
pArray EQU <[ebp+8]>
count  EQU <[ebp+12]>


IF Optimized

;---------------------------------------------------------
ArraySum PROC
; Optimized version
;---------------------------------------------------------
	push ebp
	mov ebp,esp	; set frame pointer
	push esi		; save ESI

	mov eax,0		; sum = 0
	mov esi,pArray	; array pointer
	mov ecx,count	; count
L1:
	add eax,[esi]	; add value to sum
	add esi,4		; next array position
	loopd L1

	pop esi		; restore ESI
	pop ebp
	ret			; return sum (EAX)
ArraySum ENDP

ELSE

;---------------------------------------------------------
ArraySum PROC
; Non-optimized version
;---------------------------------------------------------
	push ebp
	mov ebp,esp	; set frame pointer
	sub esp,4		; create the sum variable
	push esi		; save ESI

	mov DWORD PTR sum,0
	mov esi,pArray
	mov ecx,count
L1:
	mov eax,[esi]	; get array value
	add sum,eax	; add to sum
	add esi,4		; next array position
	loopd L1

	pop esi		; restore ESI
	mov eax,sum	; put return value in EAX
	mov esp,ebp	; remove local variables
	pop ebp
	ret
ArraySum ENDP

ENDIF

END main