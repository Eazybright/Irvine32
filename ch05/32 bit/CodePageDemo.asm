; CodePageDemo.asm

; Displays character codes 1 to 255. Select from the
; following codepages for single-byte character sets:
; 1250 - Central Europe
; 1251 - Cyrillic
; 1252 - Latin I
; 1253 - Greek
; 1254 - Turkish
; 1255 - Hebrew
; 1256 - Arabic
; 1247 - Baltic
; 1258 - Vietnam
; 874  - Thai
; 437  - OEM United States
; 858  - OEM Multilingual Latin and European

INCLUDE Irvine32.inc
SetConsoleOutputCP PROTO, pageNum:DWORD

.data
divider    BYTE " - ",0
codepage   DWORD 1252

.code
main PROC
	invoke SetConsoleOutputCP, codePage

	mov  ecx,255
	mov  eax,1
	mov  edx,OFFSET divider
L1:	
	call	WriteDec		; EAX is a counter
	call	WriteString	; EDX points to string
	call	WriteChar		; AL is the character
	call Crlf
	inc  al			; next character
	Loop L1

	exit
main ENDP
END main



