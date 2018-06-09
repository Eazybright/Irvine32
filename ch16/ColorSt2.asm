TITLE Color String Example              (ColorSt2.asm)

Comment !
Demonstrates INT 10h function 13h, which writes
a string containing embedded attribute bytes to the
video display. The write mode values in AL are:
0 = string contains only character codes; cursor not
    updated after write, and attribute is in BL.
1 = string contains only character codes; cursor is
    updated after write, and attribute is in BL.
2 = string contains alternating character codes and
    attribute bytes; cursor position not updated
    after write.
3 = string contains alternating character codes and
    attribute bytes; cursor position is updated
    after write.

; Last update: 06/01/2006
!

INCLUDE Irvine16.inc

.data
colorString BYTE 'A',1Fh,'B',1Ch,'C',1Bh,'D',1Ch
row    BYTE  10
column BYTE  20

.code
main PROC
	mov  ax,@data
	mov  ds,ax

	call ClrScr
	mov  ax,SEG colorString
	mov  es,ax
	mov  ah,13h					; write string
	mov  al,2						; write mode
	mov  bh,0						; video page
	mov  cx,(SIZEOF colorString) / 2	; string length
	mov  dh,row					; start row
	mov  dl,column					; start column
	mov  bp,OFFSET colorString		; ES:BP points to string
	int  10h

	mov  ah,2						; home the cursor
	mov  dx,0
	int  10h

	exit
main ENDP

END main
