; Intro to Unions                  (Union.asm)

; This program demonstrates the UNION directive.

INCLUDE Irvine32.inc

Integer UNION
	D DWORD ?
	W WORD  ?
	B BYTE  ?
Integer ENDS

Comment @
FileInfo STRUCT
	FileID Integer <>
	FileName BYTE 64 DUP(?)
FileInfo ENDS
@

FileInfo STRUCT
  UNION FileID
	  D DWORD ?
	  W WORD  ?
	  B BYTE  ?
	ENDS
  FileName BYTE 64 DUP(?)
FileInfo ENDS

.data
val1 Integer <12345678h>
val2 Integer <>
val3 Integer <>

.code
main PROC
	mov eax,12345678h

	mov val1.B, al
	mov val2.W, ax
	mov val3.D, eax

    exit
main ENDP
END main