; Calculate Elapsed Time          (TimingLoop.asm)

; This program uses GetTickCount to calculate the number
; of milliseconds that have elapsed since the program
; started.

INCLUDE Irvine32.inc

TIME_LIMIT = 5000
.data
startTime DWORD ?
dot BYTE ".",0

.code
main PROC
	INVOKE GetTickCount
	mov startTime,eax

L1:
	mov  edx,OFFSET dot		; display a dot
	call WriteString

	INVOKE Sleep,100		; sleep for 100ms

	INVOKE GetTickCount
	sub  eax,startTime		 check the elapsed time
	cmp  eax,TIME_LIMIT
	jb   L1

L2:	exit
main ENDP
END main
