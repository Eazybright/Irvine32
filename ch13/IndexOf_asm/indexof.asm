; IndexOf function      (IndexOf.asm)

.586
.model flat,C
IndexOf PROTO,
	srchVal:DWORD, arrayPtr:PTR DWORD, count:DWORD

.code
;-----------------------------------------------
IndexOf PROC uses ecx esi edi,
	srchVal:DWORD, arrayPtr:PTR DWORD, count:DWORD
;
; Performs a linear search of a 32-bit integer array,
; looking for a specific value. If the value is found,
; the matching index position is returned in EAX; 
; otherwise, EAX equals -1.
;-----------------------------------------------
	NOT_FOUND = -1

 	mov  eax,srchVal    			; search value
 	mov  ecx,count      			; array size
	mov  esi,arrayPtr
	mov  edi,0						; index

L1: cmp  [esi+edi*4],eax
	je   found
	inc	 edi
	loop L1

notFound:	
     mov  eax,NOT_FOUND
     jmp  short exit

found:
     mov	eax,edi

exit:
	 ret			; EDI contains the index
IndexOf ENDP
END

