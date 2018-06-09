; Demonstrate MessageBoxA           (MessageBox.asm)

; Demonstration of the Windows API MessageBox function, using
; various icons and button configurations.

INCLUDE Irvine32.inc

.data
captionW		BYTE "Warning",0
warningMsg	BYTE "The current operation may take years "
				BYTE "to complete.",0

captionQ		BYTE "Question",0 
questionMsg	BYTE "A matching user account was not found."
				BYTE 0dh,0ah,"Do you wish to continue?",0	

captionC		BYTE "Information",0
infoMsg		BYTE "Select Yes to save a backup file "
				BYTE "before continuing,",0dh,0ah
				BYTE "or click Cancel to stop the operation",0

captionH		BYTE "Cannot View User List",0
haltMsg		BYTE "This operation not supported by your "
				BYTE "user account.",0	            

.code
main PROC

; Display Exclamation icon with OK button
	INVOKE MessageBox, NULL, ADDR warningMsg, 
		ADDR captionW, 
		MB_OK + MB_ICONEXCLAMATION

; Display Question icon with Yes/No buttons
	INVOKE MessageBox, NULL, ADDR questionMsg, 
		ADDR captionQ, MB_YESNO + MB_ICONQUESTION
		
	; interpret the button clicked by the user	
	cmp	eax,IDYES		; YES button clicked?

; Display Information icon with Yes/No/Cancel buttons 
	INVOKE MessageBox, NULL, ADDR infoMsg, 
	  ADDR captionC, MB_YESNOCANCEL + MB_ICONINFORMATION \
	  	+ MB_DEFBUTTON2

; Display stop icon with OK button
	INVOKE MessageBox, NULL, ADDR haltMsg, 
		ADDR captionH, 
		MB_OK + MB_ICONSTOP

	exit
main ENDP

END main 
