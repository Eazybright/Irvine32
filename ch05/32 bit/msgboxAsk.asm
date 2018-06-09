; MsgBoxAsk demo                     (msgboxAsk.asm)

INCLUDE Irvine32.inc

.data
caption BYTE "Survey Completed",0
question BYTE "Thank you for completing the survey."
	BYTE 0dh,0ah
	BYTE "Would you like to receive the results?",0
results BYTE "The results will be sent via email.",0dh,0ah,0

.code
main PROC

	mov ebx,OFFSET caption
	mov edx,OFFSET question
	call MsgBoxAsk
	;(check return value in EAX)

	exit
main ENDP

END main 
