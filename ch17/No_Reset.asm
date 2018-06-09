TITLE Reset-Disabling program                  (No_Reset.asm)

; This program disables the usual DOS reset command
; (Ctrl-Alt-Del), by intercepting the INT 9 keyboard
; hardware interrupt.  It checks the shift status bits
; in the MS-DOS keyboard flag and changes any Ctrl-Alt-Del
; to Alt-Del.  The computer can only be rebooted by
; typing Ctrl+Alt+Right shift+Del.  Assemble, link,
; and convert to a COM program by including the /T
; command on the Microsoft LINK command line.
; Last update: 12/12/2004

.model tiny
.386
.code
	rt_shift   EQU 01h		; Right shift key: bit 0
	ctrl_key   EQU 04h		; CTRL key: bit 2
	alt_key    EQU 08h		; ALT key: bit 3
	del_key    EQU 53h		; scan code for DEL key
	kybd_port  EQU 60h		; keyboard input port

	ORG   100h       		; this is a COM program
start:
	jmp   setup      		; jump to TSR installation

;   Memory-resident code begins here
int9_handler PROC FAR
	sti               		; enable hardware interrupts
	pushf		; save regs & flags
	push  es
	push  ax
	push  di

;   Point ES:DI to the DOS keyboard flag byte:
L1:	mov   ax,40h             		; DOS data segment is at 40h
	mov   es,ax
	mov   di,17h             		; location of keyboard flag
	mov   ah,es:[di]         		; copy keyboard flag into AH

;   Test for the CTRL and ALT keys:
L2:	test  ah,ctrl_key        		; CTRL key held down?
	jz    L5                 		; no: exit
	test  ah,alt_key         		; ALT key held down?
	jz    L5                 		; no: exit

;   Test for the DEL and Right-shift keys:
L3:	in    al,kybd_port       		; read keyboard port
	cmp   al,del_key         		; DEL key pressed?
	jne   L5                 		; no: exit
	test  ah,rt_shift        		; right shift key pressed?
	jnz   L5                 		; yes: allow system reset

L4:	and   ah,NOT ctrl_key    		; no: turn off bit for CTRL
	mov   es:[di],ah         		; store keyboard_flag

L5:	pop   di                 		; restore regs & flags
	pop   ax
	pop   es
	popf
	jmp   cs:[old_interrupt9]		; jump to INT 9 routine

old_interrupt9 DWORD ?

int9_handler ENDP
end_ISR label BYTE

; --------------- (end of TSR program) ------------------
;   Save a copy of the original INT 9 vector, and set up
;   the address of our program as the new vector.  Terminate
;   this program and leave the int9_handler procedure in memory.

setup:
	mov ax,3509h           		; get INT 9 vector
	int 21h
	mov word ptr old_interrupt9,bx		; save INT 9 vector
	mov word ptr old_interrupt9+2,es

	mov ax,2509h           		; set interrupt vector, INT 9
	mov dx,offset int9_handler
	int 21h

	mov ax,3100h			; terminate and stay resident
	mov dx,OFFSET end_ISR  		; point to end of resident code
	shr dx,4			; divide by 16
	inc dx				; round upward to next paragraph
	int 21h               		; execute MS-DOS function
END start