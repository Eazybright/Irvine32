TITLE Test the Irvine32 Link Library      (LibTest.asm)

; Use this program to test the Irvine32.asm library.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.data
temp BYTE "#H",0         
delimiter BYTE "#"

.code
main PROC
     movzx eax,delimiter
     push  eax
     push  offset temp
     call Str_trim2


    exit
main ENDP

;-----------------------------------------------------------
Str_trim2 PROC USES eax ecx edi,
	pString:PTR BYTE,			; points to string
	char:BYTE					; char to remove
;
; NEW VERSION, DOES NOT USE SCASB
; Remove all occurences of a given character from
; the end of a string. 
; Returns: nothing
; Last update: 5/2/09
;-----------------------------------------------------------
	mov  edi,pString
	INVOKE Str_length,edi         ; puts length in EAX
	cmp  eax,0                    ; length zero?
	je   L3                       ; yes: exit now
	mov  ecx,eax                  ; no: ECX = string length
	dec  eax                      
	add  edi,eax                  ; point to null byte at end
	
L1:	mov  al,[edi]				; get a character
    	cmp  al,char                  ; character to be trimmed?
    	jne  L2                       ; no: insert null byte
    	dec  edi                      ; yes: keep backing up
     loop L1                       ; until beginning reached

L2:  mov  BYTE PTR [edi+1],0       ; insert a null byte
L3:  ret
Str_trim2 ENDP


END main