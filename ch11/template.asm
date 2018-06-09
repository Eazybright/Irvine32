; Demonstrate the MessageBoxA function     (MessageBox.asm)

.386p
.model flat,stdcall
.stack 1000h

INCLUDE Irvine32.inc

MessageBoxA PROTO, hWnd:DWORD, lpText:PTR BYTE,
	lpCaption:PTR BYTE, style:DWORD
	
ExitProcess PROTO, dwExitCode:DWORD

	
MB_OK = 0
NULL = 0

.data
caption db "Message Title",0 

helloMsg BYTE "This is a simple message" 
	     BYTE 0dh, 0ah, "Click OK to close the box",0 
	     
consoleMsg BYTE "Appears in the console window",0dh,0ah,0	     
        
questionMsg BYTE "Do you want to quit?",0	     

.code
main PROC

	call simple_message

	; How does popup synchronize with console window?
	mov	edx,OFFSET consoleMsg
	call	WriteString
	call	Crlf

	INVOKE ExitProcess, 0 

main ENDP

;-----------------------------------------------
simple_message PROC
;-----------------------------------------------
	pushad
	
	INVOKE MessageBoxA, NULL, ADDR helloMsg, 
		ADDR caption, MB_OK 
	
	popad
	ret
simple_message ENDP

;-----------------------------------------------
question_message PROC
;-----------------------------------------------
	pushad
	
	INVOKE MessageBoxA, NULL, ADDR helloMsg, 
		ADDR caption, MB_OK 
	
	popad
	ret
question_message ENDP


END main 
