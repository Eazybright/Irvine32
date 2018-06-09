; Macro Functions            (HelloNew.asm)

; Shows how to use macros to configure
; a program to run on multiple platforms.

INCLUDE Macros.inc
IF IsDefined( RealMode )
	INCLUDE Irvine16.inc
ELSE
	INCLUDE Irvine32.inc
ENDIF

.code
main PROC
	Startup

	mWrite <"This program can be assembled to run ",0dh,0ah>
	mWrite <"in both Real mode and Protected mode.",0dh,0ah>

	exit
main ENDP
END main