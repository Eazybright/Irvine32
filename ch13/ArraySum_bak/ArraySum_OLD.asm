TITLE	D:\Kip\AsmBook4\Examples\HLL_Linking\VisualCPP\ArraySum\ArraySum.cpp
	.386P
include listing.inc
.model FLAT

PUBLIC	?MySub@@YAXXZ					; MySub
EXTRN	__fltused:NEAR

_TEXT	SEGMENT

_A$ = -4
_B$ = -8
_name$ = -28
_c$ = -36

?MySub@@YAXXZ PROC NEAR					; MySub, COMDAT

	push	ebp
	mov	ebp, esp
	sub	esp, 100				; local variables
	push	ebx
	push	esi
	push	edi

	mov	BYTE PTR _A$[ebp], 'A'    ; [ebp-4]
	mov	DWORD PTR _B$[ebp], 10			; [ebp-8]
	mov	BYTE PTR _name$[ebp],'B'     ; [ebp-28]
	mov	DWORD PTR _c$[ebp], 33333333H   ; [ebp-36]
	mov	DWORD PTR _c$[ebp+4], 3ff33333H ; [ebp-32]

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?MySub@@YAXXZ ENDP

_TEXT	ENDS
PUBLIC	?ArraySum@@YAHQAHH@Z				; ArraySum
;	COMDAT ?ArraySum@@YAHQAHH@Z
_TEXT	SEGMENT
_array$ = 8
_count$ = 12
_sum$ = -4
_i$ = -8
?ArraySum@@YAHQAHH@Z PROC NEAR				; ArraySum, COMDAT

; 13   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 72					; 00000048H
	push	ebx
	push	esi
	push	edi
	lea	edi, DWORD PTR [ebp-72]
	mov	ecx, 18					; 00000012H
	mov	eax, -858993460				; ccccccccH
	rep stosd

; 14   : 	int sum = 0;

	mov	DWORD PTR _sum$[ebp], 0

; 15   : 
; 16   : 	for(int i = 0; i < count; i++)

	mov	DWORD PTR _i$[ebp], 0
	jmp	SHORT $L277
$L278:
	mov	eax, DWORD PTR _i$[ebp]
	add	eax, 1
	mov	DWORD PTR _i$[ebp], eax
$L277:
	mov	ecx, DWORD PTR _i$[ebp]
	cmp	ecx, DWORD PTR _count$[ebp]
	jge	SHORT $L279

; 17   : 	  sum += array[i];

	mov	edx, DWORD PTR _i$[ebp]
	mov	eax, DWORD PTR _array$[ebp]
	mov	ecx, DWORD PTR _sum$[ebp]
	add	ecx, DWORD PTR [eax+edx*4]
	mov	DWORD PTR _sum$[ebp], ecx
	jmp	SHORT $L278
$L279:

; 18   : 	
; 19   : 	return sum;

	mov	eax, DWORD PTR _sum$[ebp]

; 20   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?ArraySum@@YAHQAHH@Z ENDP				; ArraySum
_TEXT	ENDS
PUBLIC	_main
EXTRN	__chkesp:NEAR
;	COMDAT _main
_TEXT	SEGMENT
_Array$ = -200
_sum$ = -204
_main	PROC NEAR					; COMDAT

; 24   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 268				; 0000010cH
	push	ebx
	push	esi
	push	edi
	lea	edi, DWORD PTR [ebp-268]
	mov	ecx, 67					; 00000043H
	mov	eax, -858993460				; ccccccccH
	rep stosd

; 25   : 	int Array[50];
; 26   : 
; 27   : 	int sum = ArraySum( Array, 50 );

	push	50					; 00000032H
	lea	eax, DWORD PTR _Array$[ebp]
	push	eax
	call	?ArraySum@@YAHQAHH@Z			; ArraySum
	add	esp, 8
	mov	DWORD PTR _sum$[ebp], eax

; 28   : 
; 29   : 
; 30   : }

	pop	edi
	pop	esi
	pop	ebx
	add	esp, 268				; 0000010cH
	cmp	ebp, esp
	call	__chkesp
	mov	esp, ebp
	pop	ebp
	ret	0
_main	ENDP
_TEXT	ENDS
END
