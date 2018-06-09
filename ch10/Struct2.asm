; Nested Structures              (Struct2.asm)

; This program shows how to declare nested
; structures, and how to access the members.

INCLUDE Irvine32.inc

Rectangle STRUCT
	UpperLeft COORD <>
	LowerRight COORD <>
Rectangle ENDS

.data
rect1 Rectangle <>
rect2 Rectangle { }
rect3 Rectangle { {10,20}, {5,15} }
rect4 Rectangle < <10,20>, <5,15> >

.code
main PROC

; Direct reference to a nested member.
	mov rect1.UpperLeft.X,30

; Using an indirect operand, access a
; nested member.
	mov esi,OFFSET rect1
	mov (Rectangle PTR [esi]).UpperLeft.Y, 40

; Get the offsets of individual members.
	mov edi,OFFSET rect2.LowerRight
	mov edi,OFFSET rect2.LowerRight.X

	exit
main ENDP
END main