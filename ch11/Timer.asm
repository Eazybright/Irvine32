; Calculate Elapsed Time               (Timer.asm)

; Demonstrate a simple stopwatch timer, using
; the Win32 GetTickCount function.

INCLUDE Irvine32.inc
INCLUDE macros.inc

.data
startTime DWORD ?

.code
main PROC
	INVOKE GetTickCount		; get starting tick count
	mov	startTime,eax		; save it

; Create a useless calculation loop.
	mov	ecx,10000100h
L1:	imul	ebx
	imul	ebx
	imul	ebx
	loop	L1

	INVOKE GetTickCount		; get new tick count
	cmp	eax,startTime		; lower than starting one?
	jb	error			; it wrapped around
	
	sub	eax,startTime		; get elapsed milliseconds
	call	WriteDec			; display it
	mWrite <" milliseconds have elapsed",0dh,0ah>
	jmp	quit

error:
	mWrite "Error: GetTickCount invalid--system has "
	mWrite <"been active for more than 49.7 days",0dh,0ah>
quit:
	exit
main ENDP

END main