	TITLE	strings.cpp
	.386P
include listing.inc
if @Version gt 510
.model FLAT
else
_TEXT	SEGMENT PARA USE32 PUBLIC 'CODE'
_TEXT	ENDS
_DATA	SEGMENT DWORD USE32 PUBLIC 'DATA'
_DATA	ENDS
CONST	SEGMENT DWORD USE32 PUBLIC 'CONST'
CONST	ENDS
_BSS	SEGMENT DWORD USE32 PUBLIC 'BSS'
_BSS	ENDS
$$SYMBOLS	SEGMENT BYTE USE32 'DEBSYM'
$$SYMBOLS	ENDS
$$TYPES	SEGMENT BYTE USE32 'DEBTYP'
$$TYPES	ENDS
_TLS	SEGMENT DWORD USE32 PUBLIC 'TLS'
_TLS	ENDS
;	COMDAT ??_C@_03NBBF@tim?$AA@
CONST	SEGMENT DWORD USE32 PUBLIC 'CONST'
CONST	ENDS
;	COMDAT _MakeString
_TEXT	SEGMENT PARA USE32 PUBLIC 'CODE'
_TEXT	ENDS
;	COMDAT _main
_TEXT	SEGMENT PARA USE32 PUBLIC 'CODE'
_TEXT	ENDS
FLAT	GROUP _DATA, CONST, _BSS
	ASSUME	CS: FLAT, DS: FLAT, SS: FLAT
endif
PUBLIC	_MakeString
PUBLIC	??_C@_03NBBF@tim?$AA@				; `string'
EXTRN	_strcpy:NEAR
EXTRN	__chkesp:NEAR
;	COMDAT ??_C@_03NBBF@tim?$AA@
; File - strings.cpp
CONST	SEGMENT
??_C@_03NBBF@tim?$AA@ DB 'tim', 00H			; `string'
CONST	ENDS
;	COMDAT _MakeString
_TEXT	SEGMENT
_firstName$ = -20
_MakeString PROC NEAR					; COMDAT

; 5    : {

	push	ebp
	mov	ebp, esp
	sub	esp, 84					; 00000054H
	push	ebx
	push	esi
	push	edi
	lea	edi, DWORD PTR [ebp-84]
	mov	ecx, 21					; 00000015H
	mov	eax, -858993460				; ccccccccH
	rep stosd

; 6    : 	char firstName[20];
; 7    : 	strcpy(firstName,"tim");

	push	OFFSET FLAT:??_C@_03NBBF@tim?$AA@	; `string'
	lea	eax, DWORD PTR _firstName$[ebp]
	push	eax
	call	_strcpy
	add	esp, 8

; 8    : }

	pop	edi
	pop	esi
	pop	ebx
	add	esp, 84					; 00000054H
	cmp	ebp, esp
	call	__chkesp
	mov	esp, ebp
	pop	ebp
	ret	0
_MakeString ENDP
_TEXT	ENDS
PUBLIC	_main
;	COMDAT _main
_TEXT	SEGMENT
_main	PROC NEAR					; COMDAT

; 11   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi
	lea	edi, DWORD PTR [ebp-64]
	mov	ecx, 16					; 00000010H
	mov	eax, -858993460				; ccccccccH
	rep stosd

; 12   : 	MakeString();

	call	_MakeString

; 13   : }

	pop	edi
	pop	esi
	pop	ebx
	add	esp, 64					; 00000040H
	cmp	ebp, esp
	call	__chkesp
	mov	esp, ebp
	pop	ebp
	ret	0
_main	ENDP
_TEXT	ENDS
END
