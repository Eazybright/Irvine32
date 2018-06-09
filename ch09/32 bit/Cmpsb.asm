; Comparing Strings             (Cmpsb.asm)

; This program uses CMPSB to compare two strings
; of equal length.

INCLUDE Irvine32.inc
.data
source BYTE "MARTIN  "
dest   BYTE "MARTINEZ"
str1   BYTE "Source is smaller",0dh,0ah,0
str2   BYTE "Source is not smaller",0dh,0ah,0

.code
main PROC
	cld					; direction = forward
	mov  esi,OFFSET source
	mov  edi,OFFSET dest
	mov  cx,LENGTHOF source
	repe cmpsb
	jb   source_smaller
	mov  edx,OFFSET str2
	jmp  done

source_smaller:
	mov  edx,OFFSET str1

done:
	call WriteString
	exit
main ENDP
END main